-- Task 1: Annual sales value
-- Goal: Calculate total sales value for each year.
SELECT 
    YEAR(soh.OrderDate) AS SalesYear
    , SUM(soh.TotalDue) AS TotalSalesAmount
FROM Sales.SalesOrderHeader soh
GROUP BY
    YEAR(soh.OrderDate)
ORDER BY
    SalesYear;

-- Task 2: Top 20 best-selling products
-- Goal: Display the 20 most frequently sold products by total quantity sold.
SELECT TOP 20
    p.ProductID
    , p.Name AS ProductName
    , SUM(sod.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail sod
INNER JOIN Production.Product p
    ON p.ProductID = sod.ProductID
GROUP BY
    p.ProductID
    , p.Name
ORDER BY
    TotalQuantitySold DESC;

-- Task 3: Sales value by salesperson
-- Goal: Calculate total order value for each salesperson with assigned orders.
SELECT 
    sp.BusinessEntityID AS SalesPersonID
    , pp.FirstName + ' ' + pp.LastName AS SalesPersonName
    , SUM(soh.TotalDue) AS TotalOrderValue
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesPerson sp
    ON soh.SalesPersonID = sp.BusinessEntityID
INNER JOIN Person.Person pp
    ON sp.BusinessEntityID = pp.BusinessEntityID
GROUP BY
    sp.BusinessEntityID
    , pp.FirstName
    , pp.LastName
ORDER BY
    TotalOrderValue DESC;

-- Task 4: Product price statistics by subcategory
-- Goal: Calculate the lowest, average and highest product list price for each subcategory.
SELECT 
    ps.ProductSubcategoryID
    , ps.Name AS SubcategoryName
    , MIN(p.ListPrice) AS MinListPrice
    , AVG(p.ListPrice) AS AvgListPrice
    , MAX(p.ListPrice) AS MaxListPrice
FROM Production.Product p
INNER JOIN Production.ProductSubcategory ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE p.ListPrice > 0
GROUP BY
    ps.ProductSubcategoryID
    , ps.Name
ORDER BY
    AvgListPrice DESC;

-- Task 5: Customer order count and average order value
-- Goal: Calculate the number of orders and average order value for customers with more than 5 orders.
SELECT 
    soh.CustomerID
    , COUNT(soh.SalesOrderID) AS OrderCount
    , AVG(soh.TotalDue) AS AvgOrderValue
FROM Sales.SalesOrderHeader soh
GROUP BY
    soh.CustomerID
HAVING COUNT(soh.SalesOrderID) > 5
ORDER BY
    OrderCount DESC;
