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
==========================================================================
*/


-- -----------------------------------------------------------------------
-- 1. BASIC DATA EXPLORATION
-- -----------------------------------------------------------------------

-- Total number of transactions
SELECT COUNT(*) AS total_transactions
FROM clean_transaction_sales;

-- Total number of unique customers
SELECT COUNT(DISTINCT customer_code) AS total_customers
FROM clean_customers;

-- Preview first 10 transactions
SELECT *
FROM clean_transaction_sales
LIMIT 10;

-- Check for negative or zero sales values (Data Validation)
SELECT *
FROM clean_transaction_sales
WHERE sales_amount <= 0;


-- -----------------------------------------------------------------------
-- 2. REVENUE & MARKET INSIGHTS
-- -----------------------------------------------------------------------

-- Total Revenue (Overall)
SELECT SUM(norm_sales_amount) AS total_revenue
FROM clean_transaction_sales;

-- Total Revenue by Market (Top 10 Markets)
SELECT
    m.markets_name,
    SUM(t.norm_sales_amount) AS total_revenue
FROM clean_transaction_sales t
JOIN clean_markets m
    ON t.market_code = m.market_code
GROUP BY m.markets_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Total Sales Quantity by Zone
SELECT
    m.zone,
    SUM(t.sales_qty) AS total_quantity
FROM clean_transaction_sales t
JOIN clean_markets m
    ON t.market_code = m.market_code
GROUP BY m.zone
ORDER BY total_quantity DESC;


-- -----------------------------------------------------------------------
-- 3. PRODUCT & CUSTOMER PERFORMANCE
-- -----------------------------------------------------------------------

-- Top 5 Best-Selling Products by Quantity
SELECT
    product_code,
    SUM(sales_qty) AS total_qty_sold
FROM clean_transaction_sales
GROUP BY product_code
ORDER BY total_qty_sold DESC
LIMIT 5;

-- Top 5 Customers by Revenue in 2019
SELECT
    c.customer_name,
    SUM(t.norm_sales_amount) AS total_revenue
FROM clean_transaction_sales t
JOIN clean_customers c
    ON t.customer_code = c.customer_code
JOIN clean_sales_years y
    ON t.order_date = y.order_date
WHERE y.year = 2019
GROUP BY c.customer_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Revenue by Customer Type
SELECT
    c.customer_type,
    SUM(t.norm_sales_amount) AS total_revenue
FROM clean_transaction_sales t
JOIN clean_customers c
    ON t.customer_code = c.customer_code
GROUP BY c.customer_type
ORDER BY total_revenue DESC;


-- -----------------------------------------------------------------------
-- 4. TREND ANALYSIS
-- -----------------------------------------------------------------------

-- Monthly Revenue Trend for 2018
SELECT
    y.month_name,
    SUM(t.norm_sales_amount) AS monthly_revenue
FROM clean_transaction_sales t
JOIN clean_sales_years y
    ON t.order_date = y.order_date
WHERE y.year = 2018
GROUP BY y.month_name
ORDER BY MIN(t.order_date);

-- Yearly Revenue Trend
SELECT
    y.year,
    SUM(t.norm_sales_amount) AS yearly_revenue
FROM clean_transaction_sales t
JOIN clean_sales_years y
    ON t.order_date = y.order_date
GROUP BY y.year
ORDER BY y.year;


-- -----------------------------------------------------------------------
-- 5. BUSINESS KPI ANALYSIS
-- -----------------------------------------------------------------------

-- Revenue Share by Transaction Channel (Brick & Mortar vs E-Commerce)
SELECT
    c.customer_type,
    SUM(t.norm_sales_amount) AS total_revenue,
    ROUND(
        SUM(t.norm_sales_amount) * 100.0 /
        (SELECT SUM(norm_sales_amount) FROM clean_transaction_sales),
        2
    ) AS revenue_percentage
FROM clean_transaction_sales t
JOIN clean_customers c
    ON t.customer_code = c.customer_code
GROUP BY c.customer_type;

-- Top 3 Markets Contributing Maximum Revenue (Pareto Insight)
SELECT
    m.markets_name,
    SUM(t.norm_sales_amount) AS total_revenue
FROM clean_transaction_sales t
JOIN clean_markets m
    ON t.market_code = m.market_code
GROUP BY m.markets_name
ORDER BY total_revenue DESC
LIMIT 3;
