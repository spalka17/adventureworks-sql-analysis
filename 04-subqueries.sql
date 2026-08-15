-- Task 1: Products with at least one order
-- Goal: Find all products that have been ordered at least once.
SELECT 
    p.ProductID
    , p.Name AS ProductName
FROM Production.Product p
WHERE EXISTS (
    SELECT 1
    FROM Sales.SalesOrderDetail sod
    WHERE p.ProductID = sod.ProductID
);

-- Task 2: Customers with no orders
-- Goal: Find customers who have never placed an order.
SELECT 
    c.CustomerID
FROM Sales.Customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.SalesOrderHeader soh
    WHERE c.CustomerID = soh.CustomerID
);

-- Task 3: Top 20 products by sales value
-- Goal: Use a derived table to calculate sales value for each product, then display the top 20 products.

SELECT TOP 20
    p.ProductID
    , p.Name AS ProductName
    , sales.TotalSalesValue
FROM (
    SELECT 
        sod.ProductID
        , SUM(sod.LineTotal) AS TotalSalesValue
    FROM Sales.SalesOrderDetail sod
    GROUP BY sod.ProductID
) AS sales
INNER JOIN Production.Product p
    ON sales.ProductID = p.ProductID
ORDER BY sales.TotalSalesValue DESC;

-- Task 4: Products above average subcategory price
-- Goal: Find products that are more expensive than the average price in their subcategory.
SELECT
    p1.ProductID
    , p1.Name AS ProductName
    , p1.ProductSubcategoryID
    , p1.ListPrice
FROM Production.Product p1
WHERE p1.ListPrice > (
    SELECT AVG(p2.ListPrice)
    FROM Production.Product p2
    WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID
)
AND p1.ListPrice > 0;

-- Task 5: Customer last order and order count
-- Goal: For each customer, display the latest order ID and total number of orders.
SELECT 
    c.CustomerID
    , (SELECT MAX(soh.SalesOrderID)
        FROM Sales.SalesOrderHeader soh
        WHERE soh.CustomerID = c.CustomerID
    ) AS LastOrderID
    , (SELECT COUNT(soh.SalesOrderID)
        FROM Sales.SalesOrderHeader soh
        WHERE soh.CustomerID = c.CustomerID
    ) AS OrderCount
FROM Sales.Customer c
WHERE EXISTS (
    SELECT 1
    FROM Sales.SalesOrderHeader soh2
    WHERE soh2.CustomerID = c.CustomerID
);
