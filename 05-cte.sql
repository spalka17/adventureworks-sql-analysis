-- Task 1: Product sales value, ranking and share of total sales
-- Goal: Calculate total sales value per product, rank products by sales value and calculate each product's share of total sales.
WITH ProductSales AS (
    SELECT 
        p.ProductID
        , p.Name AS ProductName
        , SUM(sod.LineTotal) AS SalesAmount
    FROM Sales.SalesOrderDetail sod
    INNER JOIN Production.Product p
        ON sod.ProductID = p.ProductID
    GROUP BY
        p.ProductID
        , p.Name
)

SELECT 
    ProductID
    , ProductName
    , SalesAmount
    , SUM(SalesAmount) OVER () AS TotalSalesAmount
    , ROUND((SalesAmount / SUM(SalesAmount) OVER ()) * 100, 2) AS SalesSharePercent
    , RANK() OVER (ORDER BY SalesAmount DESC) AS SalesRank
FROM ProductSales
ORDER BY SalesRank;

-- Task 2: Salesperson yearly sales and running total
-- Goal: Calculate yearly sales value for each salesperson and add a running total within each salesperson.
WITH SalespersonYearSales AS (
    SELECT
        sp.BusinessEntityID AS SalesPersonID
        , p.FirstName + ' ' + p.LastName AS SalesPersonName
        , YEAR(soh.OrderDate) AS SalesYear
        , SUM(soh.TotalDue) AS SalesAmount
    FROM Sales.SalesOrderHeader soh
    INNER JOIN Sales.SalesPerson sp
        ON sp.BusinessEntityID = soh.SalesPersonID
    INNER JOIN Person.Person p
        ON p.BusinessEntityID = sp.BusinessEntityID
    GROUP BY
       sp.BusinessEntityID
       , p.FirstName + ' ' + p.LastName
       , YEAR(soh.OrderDate)
)

SELECT 
    SalesPersonID
    , SalesPersonName
    , SalesYear
    , SalesAmount
    , SUM(SalesAmount) OVER (PARTITION BY SalesPersonID ORDER BY SalesYear) AS RunningSalesAmount
FROM SalespersonYearSales
ORDER BY
    SalesPersonID
    , SalesYear;

-- Task 3: Annual product sales and YoY change
-- Goal: Calculate annual sales for each product and compare it with the previous year using CTEs and LAG().
WITH ProductYearSales AS (
    SELECT 
        sod.ProductID AS ProductID
        , YEAR(soh.OrderDate) AS OrderYear
        , SUM(sod.LineTotal) AS AnnualSales
    FROM Sales.SalesOrderHeader soh 
    INNER JOIN Sales.SalesOrderDetail sod
        ON soh.SalesOrderID = sod.SalesOrderID
    GROUP BY
        sod.ProductID
        , YEAR(soh.OrderDate)
),

SalesWithYoY AS (
    SELECT
        ProductID
        , OrderYear
        , AnnualSales
        , LAG(AnnualSales) OVER (PARTITION BY ProductID ORDER BY OrderYear) AS PreviousYearSales
        , AnnualSales - LAG(AnnualSales) OVER (PARTITION BY ProductID ORDER BY OrderYear) AS YoYChange
    FROM ProductYearSales
)

SELECT 
    ProductID
    , OrderYear
    , AnnualSales
    , PreviousYearSales
    , YoYChange
FROM SalesWithYoY
ORDER BY
    ProductID
    , OrderYear;

-- Task 4: Regional sales ranking and median comparison
-- Goal: Calculate total sales by territory, rank territories by sales value and compare each territory with the median sales value.
WITH TerritorySales AS (
    SELECT 
        soh.TerritoryID
        , SUM(soh.TotalDue) AS SalesAmount
    FROM Sales.SalesOrderHeader soh
    GROUP BY soh.TerritoryID
),

TerritoryRanking AS (
    SELECT 
        TerritoryID
        , SalesAmount
        , RANK() OVER (ORDER BY SalesAmount DESC) AS SalesRank
        , PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY SalesAmount) OVER () AS MedianSalesAmount
    FROM TerritorySales
)

SELECT 
    TerritoryID
    , SalesAmount
    , SalesRank
    , MedianSalesAmount
    , SalesAmount - MedianSalesAmount AS DifferenceFromMedian
FROM TerritoryRanking
ORDER BY SalesRank;

-- Task 5: Monthly product sales, 3-month moving average and monthly ranking
-- Goal: Calculate monthly sales for each product, add a 3-month moving average and rank products within each month.
WITH MonthlyProductSales AS (
    SELECT 
        p.ProductID
        , p.Name AS ProductName
        , YEAR(soh.OrderDate) AS SalesYear
        , MONTH(soh.OrderDate) AS SalesMonth
        , SUM(sod.LineTotal) AS MonthlySalesAmount
    FROM Sales.SalesOrderDetail sod
    INNER JOIN Sales.SalesOrderHeader soh
        ON sod.SalesOrderID = soh.SalesOrderID
    INNER JOIN Production.Product p
        ON sod.ProductID = p.ProductID
    GROUP BY
        p.ProductID
        , p.Name
        , YEAR(soh.OrderDate)
        , MONTH(soh.OrderDate)
)

SELECT 
    ProductID
    , ProductName
    , SalesYear
    , SalesMonth
    , MonthlySalesAmount
    , AVG(MonthlySalesAmount) OVER (PARTITION BY ProductID ORDER BY SalesYear, SalesMonth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg3Months
    , RANK() OVER (PARTITION BY SalesYear, SalesMonth ORDER BY MonthlySalesAmount DESC) AS MonthlySalesRank
FROM MonthlyProductSales
ORDER BY
    SalesYear
    , SalesMonth
    , MonthlySalesRank;
