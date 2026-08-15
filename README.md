# AdventureWorks SQL Analysis

This repository contains SQL Server exercises based on the AdventureWorks2022 sample database.

The project was created as part of my SQL learning and portfolio development. Its goal is to demonstrate practical SQL skills used in data analysis, including joins, aggregations, window functions, subqueries, common table expressions and query optimization.

## Database

The exercises are based on the Microsoft AdventureWorks2022 sample database.

To better understand table relationships, primary keys, foreign keys and joins between tables, I used the AdventureWorks database diagram as a reference:

[AdventureWorks database diagram](https://www.dbdiagrams.com/online-diagrams/adventureworks/index.html?page=Diagrams&item=itm-b11f58da-3554-4636-86c6-edf49dadebc1)

## Skills covered

* Filtering and sorting data
* Joining multiple tables
* Aggregating data with `GROUP BY` and `HAVING`
* Using window functions with `OVER()` and `PARTITION BY`
* Writing subqueries with `EXISTS`, `NOT EXISTS` and derived tables
* Building analytical queries with CTEs
* Creating SQL functions and temporary tables
* Understanding indexes, SARGability and execution plans

## Repository structure

```text
adventureworks-sql-analysis/
│
├── 01-joins.sql
├── 02-aggregations.sql
├── 03-window-functions.sql
├── 04-subqueries.sql
├── 05-cte.sql
├── 06-functions-and-temp-tables.sql
├── 07-indexes-and-optimization.sql
│
└── images/
    ├── index-task-01-like-wildcard.png
    ├── index-task-02-date-range.png
    ├── index-task-03-pln-conversion.png
    ├── index-task-04-composite-index.png
    └── index-task-05-selectivity.png
```

## Project sections

### 01 - Joins

This section includes queries that combine data from multiple AdventureWorks tables.

The tasks cover examples such as:

* products that were never ordered
* orders with shipping address details
* salespeople and their sales territories
* employees currently working in a selected department
* orders with products from a specific category shipped to a selected country

### 02 - Aggregations

This section focuses on business-oriented aggregation tasks.

Examples include:

* annual sales value
* top-selling products
* sales value by salesperson
* product price statistics by subcategory
* customer order count and average order value

This part uses SQL techniques such as `SUM()`, `COUNT()`, `AVG()`, `MIN()`, `MAX()`, `GROUP BY`, `HAVING`, `TOP` and `ORDER BY`.

### 03 - Window Functions

This section contains examples of SQL window functions.

The tasks include:

* product price comparison with category average
* running total of order values by customer
* order numbering within each customer
* product price ranking within category
* difference between product price and maximum subcategory price

Functions used in this section include:

* `AVG() OVER`
* `SUM() OVER`
* `ROW_NUMBER() OVER`
* `RANK() OVER`
* `MAX() OVER`

### 04 - Subqueries

This section demonstrates different types of SQL subqueries.

It includes examples of:

* `EXISTS`
* `NOT EXISTS`
* derived tables in `FROM`
* correlated subqueries in `WHERE`
* scalar correlated subqueries in `SELECT`

The tasks cover business questions such as finding products with orders, customers without orders, top products by sales value and customer order activity.

### 05 - Common Table Expressions

This section contains more advanced analytical queries using CTEs.

Examples include:

* product sales value, ranking and share of total sales
* yearly sales by salesperson with running total
* annual product sales with year-over-year change
* regional sales ranking and comparison with median sales
* monthly product sales with 3-month moving average and monthly ranking

This section combines CTEs with analytical functions such as `RANK()`, `LAG()`, `SUM() OVER`, `AVG() OVER` and `PERCENTILE_CONT()`.

### 06 - Functions and Temporary Tables

This section is currently in progress.

It will include examples of:

* scalar functions
* table-valued functions
* temporary tables
* multi-step SQL analysis using intermediate results

### 07 - Indexes and Optimization

This section contains selected SQL Server optimization exercises focused on execution plan analysis.

The examples show how different query structures affect index usage, including:

* `Index Seek`
* `Index Scan`
* SARGable filters
* composite index column order
* filter selectivity
* calculations on columns vs calculations on values

Selected execution plan screenshots are included in the `images` folder.

Examples covered:

* `LIKE 'Bike%'` vs `LIKE '%Bike%'`
* date filtering with functions vs date ranges
* calculation on a column vs calculation on the value side
* composite index column order
* narrow vs broad filters on the same indexed column

## Tools used

* SQL Server
* SQL Server Management Studio
* AdventureWorks2022
* GitHub

## Project status

This repository is part of my SQL portfolio and is being developed gradually.

Most sections already contain completed SQL exercises. The functions and temporary tables section is still in progress and will be expanded later.
