# Sales Insights Data Analysis

## Project Overview

This project analyzes multi-dimensional sales transaction data to evaluate revenue performance, customer contribution, and market trends. The objective was to generate structured business insights that support data-driven decision-making at the management level.

The dataset includes transactions across customers, products, markets, and time dimensions, enabling relational analysis using MySQL and dashboard visualization using Power BI.

---

## Business Objectives

- Evaluate total revenue performance across markets and time periods
- Identify high-performing and underperforming regions
- Analyze monthly and yearly revenue trends
- Determine top revenue-contributing customers
- Assess channel contribution (Brick & Mortar vs E-Commerce)
- Standardize multi-currency transactions for consistent reporting

---

## Tools & Technologies

- MySQL
- SQL (Joins, Aggregations, Group By, Window Functions, Subqueries)
- Power BI
- Data Cleaning & Transformation (ETL process)

---

## Data Preparation

- Imported 5 structured datasets into MySQL (transactions, customers, products, markets, dates)
- Cleaned invalid and inconsistent transaction records (identified negative sales amount records)
- Normalized USD transactions into INR for unified revenue analysis
- Created derived metrics for business reporting
- Integrated all tables using relational SQL joins for comprehensive querying

---

## Key Business Insights 

### Revenue Overview
- **Total Revenue: ₹98.66 Crore** across all markets and years
- **Peak Year: 2018** with ₹41.43 Crore — a **+342.7% YoY growth** from 2017
- **2019 decline:** Revenue dropped by **18.8%** from peak, signaling market contraction
- **2020 sharp decline:** Revenue fell by **57.7%** — likely impacted by external market disruptions

### Top 5 Markets by Revenue
| Market | Revenue |
|--------|---------|
| Delhi NCR | ₹52.07 Crore (52.8%) |
| Mumbai | ₹15.02 Crore (15.2%) |
| Ahmedabad | ₹13.25 Crore (13.4%) |
| Bhopal | ₹5.87 Crore (5.9%) |
| Nagpur | ₹5.50 Crore (5.6%) |

- **Delhi NCR alone contributes 52.8% of total revenue** — highest market concentration
- Top 3 markets together account for **81.4% of total revenue**

###  Top 5 Customers by Revenue
| Customer | Revenue |
|----------|---------|
| Electricalsara Stores | ₹41.39 Crore |
| Electricalslytical | ₹4.96 Crore |
| Excel Stores | ₹4.92 Crore |
| Premium Stores | ₹4.53 Crore |
| Nixon | ₹4.39 Crore |

- **Electricalsara Stores contributes ₹41.39 Crore** — nearly 42% of total revenue alone
- High customer concentration risk — top customer is 8x larger than the second highest

###  Revenue by Year (YoY Trend)
| Year | Revenue | YoY Growth |
|------|---------|------------|
| 2017 | ₹9.36 Crore | — |
| 2018 | ₹41.43 Crore | +342.7%  |
| 2019 | ₹33.65 Crore | -18.8%  |
| 2020 | ₹14.22 Crore | -57.7%  |

###  Data Quality Finding
- Identified **negative sales amount records** in raw transactions data
- Cleaned and excluded invalid entries for accurate revenue reporting
- Minor variance (~1.7M) between raw SQL total and Power BI confirmed due to filtered invalid records

---

## Key Performance Indicators (KPIs)

| KPI | Value |
|-----|-------|
| Total Revenue | ₹98.66 Crore |
| Top Market | Delhi NCR (52.8% of revenue) |
| Peak Year | 2018 (₹41.43 Crore) |
| Best YoY Growth | +342.7% (2017→2018) |
| Top Customer | Electricalsara Stores (₹41.39 Crore) |
| Customer Concentration | Top customer = 42% of revenue |

---

## Dashboard Preview

![Dashboard](dashboard.png)

---

## Project Structure

```
Sales-Insights-Data-Analysis/
├── sales-analysis.sql           → SQL queries for analytical reporting
├── dashboard.png                → Power BI dashboard output
├── clean_transaction_sales.csv  → Transaction dataset
├── clean_customers.csv          → Customer data
├── clean_products.csv           → Product data
├── clean_markets.csv            → Market data
├── clean_sales_years.csv        → Date dimension data
└── README.md                    → Project documentation
```

---

## Business Impact

The analysis revealed critical revenue concentration risks and actionable growth opportunities:

- **Delhi NCR contributes 52.8% of revenue** — heavy geographic concentration risk
- **Top customer (Electricalsara Stores) drives 42% of revenue** — high dependency risk
- **342.7% YoY growth in 2018** followed by consistent decline — signals need for market diversification
- **Top 3 markets contribute 81.4% of revenue** — remaining markets are significantly underutilized
- Data validation across MySQL and Power BI confirmed accuracy of insights with <0.2% variance

This project demonstrates strong SQL proficiency, structured analytical thinking, data validation skills, and the ability to convert raw transactional data into actionable business insights.
