/*
==========================================================================
ATLIQ HARDWARE SALES ANALYSIS PROJECT
Author: Shweta C
Tools Used: MySQL
Dataset Source: Codebasics Sales Insights Dataset

Description:
This SQL script contains structured business queries used for data
exploration, KPI generation, performance analysis, and trend insights
for the AtliQ Hardware Sales dataset.

The objective is to derive meaningful business insights such as revenue
distribution, market performance, customer contribution, product trends,
and channel-wise revenue share.

Tables Used:
- transactions       → Sales transaction records
- customers          → Customer master data
- markets            → Market and zone information
- products           → Product master data
- date               → Date dimension (year, month)
==========================================================================
*/


-- -----------------------------------------------------------------------
-- 1. BASIC DATA EXPLORATION
-- -----------------------------------------------------------------------

-- Total number of transactions
SELECT COUNT(*) AS total_transactions
FROM transactions;

-- Total number of unique customers
SELECT COUNT(DISTINCT customer_code) AS total_customers
FROM customers;

-- Preview first 10 transactions
SELECT *
FROM transactions
LIMIT 10;

-- Check distinct currency types in dataset
SELECT DISTINCT currency
FROM transactions;

-- Count of USD transactions before normalization (ETL Validation)
SELECT COUNT(*) AS usd_transactions
FROM transactions
WHERE currency = 'USD';

-- Check for negative or zero sales values (Data Quality Check)
SELECT *
FROM transactions
WHERE sales_amount <= 0;

-- Total value of negative/invalid transactions (explains Power BI variance)
SELECT SUM(sales_amount) AS invalid_revenue
FROM transactions
WHERE sales_amount <= 0;


-- -----------------------------------------------------------------------
-- 2. REVENUE & MARKET INSIGHTS
-- -----------------------------------------------------------------------

-- Total Revenue (Overall - Raw)
SELECT SUM(sales_amount) AS total_revenue_raw
FROM transactions;

-- Total Revenue (Normalized INR)
SELECT SUM(norm_sales_amount) AS total_revenue_normalized
FROM transactions;

-- Total Revenue by Market (Top 10 Markets)
SELECT
    m.markets_name,
    SUM(t.norm_sales_amount) AS total_revenue,
    ROUND(
        SUM(t.norm_sales_amount) * 100.0 /
        (SELECT SUM(norm_sales_amount) FROM transactions), 2
    ) AS revenue_percentage
FROM transactions t
JOIN markets m
    ON t.market_code = m.markets_code
GROUP BY m.markets_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Total Revenue by Zone
SELECT
    m.zone,
    SUM(t.norm_sales_amount) AS total_revenue,
    ROUND(
        SUM(t.norm_sales_amount) * 100.0 /
        (SELECT SUM(norm_sales_amount) FROM transactions), 2
    ) AS revenue_percentage
FROM transactions t
JOIN markets m
    ON t.market_code = m.markets_code
GROUP BY m.zone
ORDER BY total_revenue DESC;

-- Total Sales Quantity by Zone
SELECT
    m.zone,
    SUM(t.sales_qty) AS total_quantity
FROM transactions t
JOIN markets m
    ON t.market_code = m.markets_code
GROUP BY m.zone
ORDER BY total_quantity DESC;

-- Top 3 Markets Contributing Maximum Revenue (Pareto Insight)
SELECT
    m.markets_name,
    SUM(t.norm_sales_amount) AS total_revenue
FROM transactions t
JOIN markets m
    ON t.market_code = m.markets_code
GROUP BY m.markets_name
ORDER BY total_revenue DESC
LIMIT 3;


-- -----------------------------------------------------------------------
-- 3. PRODUCT & CUSTOMER PERFORMANCE
-- -----------------------------------------------------------------------

-- Top 5 Best-Selling Products by Quantity
SELECT
    product_code,
    SUM(sales_qty) AS total_qty_sold
FROM transactions
GROUP BY product_code
ORDER BY total_qty_sold DESC
LIMIT 5;

-- Top 5 Customers by Revenue (Overall)
SELECT
    c.custmer_name AS customer_name,
    SUM(t.norm_sales_amount) AS total_revenue
FROM transactions t
JOIN customers c
    ON t.customer_code = c.customer_code
GROUP BY c.custmer_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Top 5 Customers by Revenue in 2019
SELECT
    c.custmer_name AS customer_name,
    SUM(t.norm_sales_amount) AS total_revenue
FROM transactions t
JOIN customers c
    ON t.customer_code = c.customer_code
JOIN date d
    ON t.order_date = d.date
WHERE d.year = 2019
GROUP BY c.custmer_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Revenue by Customer Type (Brick & Mortar vs E-Commerce)
SELECT
    c.customer_type,
    SUM(t.norm_sales_amount) AS total_revenue,
    ROUND(
        SUM(t.norm_sales_amount) * 100.0 /
        (SELECT SUM(norm_sales_amount) FROM transactions), 2
    ) AS revenue_percentage
FROM transactions t
JOIN customers c
    ON t.customer_code = c.customer_code
GROUP BY c.customer_type
ORDER BY total_revenue DESC;


-- -----------------------------------------------------------------------
-- 4. TREND ANALYSIS
-- -----------------------------------------------------------------------

-- Yearly Revenue Trend
SELECT
    d.year,
    SUM(t.norm_sales_amount) AS yearly_revenue
FROM transactions t
JOIN date d
    ON t.order_date = d.date
GROUP BY d.year
ORDER BY d.year;

-- Monthly Revenue Trend for 2018 (Peak Year)
SELECT
    d.month_name,
    SUM(t.norm_sales_amount) AS monthly_revenue
FROM transactions t
JOIN date d
    ON t.order_date = d.date
WHERE d.year = 2018
GROUP BY d.month_name
ORDER BY MIN(t.order_date);

-- Monthly Revenue Trend for 2019
SELECT
    d.month_name,
    SUM(t.norm_sales_amount) AS monthly_revenue
FROM transactions t
JOIN date d
    ON t.order_date = d.date
WHERE d.year = 2019
GROUP BY d.month_name
ORDER BY MIN(t.order_date);


-- -----------------------------------------------------------------------
-- 5. WINDOW FUNCTIONS & ADVANCED ANALYSIS
-- -----------------------------------------------------------------------

-- Year over Year (YoY) Revenue Growth using LAG()
SELECT
    year,
    yearly_revenue,
    LAG(yearly_revenue) OVER (ORDER BY year) AS prev_year_revenue,
    ROUND(
        (yearly_revenue - LAG(yearly_revenue) OVER (ORDER BY year)) * 100.0 /
        LAG(yearly_revenue) OVER (ORDER BY year), 2
    ) AS yoy_growth_percent
FROM (
    SELECT
        d.year,
        SUM(t.norm_sales_amount) AS yearly_revenue
    FROM transactions t
    JOIN date d ON t.order_date = d.date
    GROUP BY d.year
) AS yearly_data
ORDER BY year;

-- Customer Revenue Ranking using DENSE_RANK()
SELECT
    customer_name,
    total_revenue,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM (
    SELECT
        c.custmer_name AS customer_name,
        SUM(t.norm_sales_amount) AS total_revenue
    FROM transactions t
    JOIN customers c ON t.customer_code = c.customer_code
    GROUP BY c.custmer_name
) AS customer_revenue;

-- Market Revenue Ranking using RANK()
SELECT
    markets_name,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS market_rank
FROM (
    SELECT
        m.markets_name,
        SUM(t.norm_sales_amount) AS total_revenue
    FROM transactions t
    JOIN markets m ON t.market_code = m.markets_code
    GROUP BY m.markets_name
) AS market_revenue;

-- 2nd Highest Sales Amount using Subquery
SELECT MAX(sales_amount) AS second_highest_sales
FROM transactions
WHERE sales_amount < (SELECT MAX(sales_amount) FROM transactions);

-- Nth Highest Sales Amount using DENSE_RANK() Window Function
-- Change rnk = N to get Nth highest (e.g. rnk = 3 for 3rd highest)
SELECT sales_amount
FROM (
    SELECT
        sales_amount,
        DENSE_RANK() OVER (ORDER BY sales_amount DESC) AS rnk
    FROM transactions
) AS ranked_sales
WHERE rnk = 2;
