-- Task 1: Product price index and category average
-- Goal: Number products within each category by price and compare each product price with the category average.
SELECT   
    p.Name AS ProductName
    , pc.Name AS CategoryName
    , p.ListPrice AS ListPrice
    , AVG(p.ListPrice) OVER (PARTITION BY pc.ProductCategoryID) AS AvgCategoryPrice
    , p.ListPrice - AVG(p.ListPrice) OVER (PARTITION BY pc.ProductCategoryID) AS PriceDeviationFromCategoryAvg
    , ROW_NUMBER() OVER (PARTITION BY pc.ProductCategoryID ORDER BY p.ListPrice) AS ProductPriceIndexInCategory
FROM Production.Product p
INNER JOIN Production.ProductSubcategory ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory pc
    ON pc.ProductCategoryID = ps.ProductCategoryID
WHERE p.ListPrice > 0;


-- Task 2: Running total by customer 
-- Goal: Calculate a running total of order values for each customer.
SELECT   
    SalesOrderID
    , CustomerID
    , OrderDate
    , TotalDue
    , SUM(TotalDue) OVER (PARTITION BY CustomerID ORDER BY OrderDate, SalesOrderID) AS RunningTotalDue
FROM Sales.SalesOrderHeader;


-- Task 3: Order numbering by customer
-- Goal: Assign an order number to each customer order based on order date.
SELECT   
    SalesOrderID
    , CustomerID
    , OrderDate
    , TotalDue
    , ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate, SalesOrderID) AS CustomerOrderNumber
FROM Sales.SalesOrderHeader;

-- Task 4: Product price ranking within category
-- Goal: Calculate price ranking for each product within its category.
SELECT   
    p.Name AS ProductName
    , pc.Name AS CategoryName
    , p.ListPrice AS ListPrice
    , RANK() OVER (PARTITION BY pc.ProductCategoryID ORDER BY p.ListPrice DESC) AS PriceRankInCategory
FROM Production.Product p
INNER JOIN Production.ProductSubcategory ps 
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory pc 
    ON pc.ProductCategoryID = ps.ProductCategoryID
WHERE p.ListPrice > 0;


-- Task 5: Price difference from maximum subcategory price
-- Goal: Show each product with its price and the difference from the highest price in the same subcategory.
SELECT 
    p.Name AS ProductName
    , ps.Name AS SubcategoryName
    , p.ListPrice AS ListPrice
    , MAX(p.ListPrice) OVER (PARTITION BY ps.ProductSubcategoryID) AS MaxSubcategoryPrice
    , p.ListPrice - MAX(p.ListPrice) OVER (PARTITION BY ps.ProductSubcategoryID) AS DifferenceFromMaxSubcategoryPrice
FROM Production.Product p
INNER JOIN Production.ProductSubcategory ps 
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE p.ListPrice > 0;
