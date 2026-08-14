-- Task 1: Display products that have never been ordered
SELECT
    p.ProductID
    , p.Name AS ProductName
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod
    ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL;

-- Task 2: Display orders placed in 2014 with their shipping address details
SELECT
    soh.SalesOrderID
    , a.AddressLine1
    , a.City
    , a.PostalCode
    , cr.Name AS CountryName
FROM Sales.SalesOrderHeader soh
INNER JOIN Person.Address a
    ON soh.ShipToAddressID = a.AddressID
INNER JOIN Person.StateProvince sp
    ON a.StateProvinceID = sp.StateProvinceID
INNER JOIN Person.CountryRegion cr
    ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE soh.OrderDate >= '2014-01-01'
  AND soh.OrderDate < '2015-01-01';

-- Task 3: Display all salespeople and their sales territories
SELECT
    sp.BusinessEntityID AS SalesPersonID
    , p.FirstName + ' ' + p.LastName AS SalesPersonName
    , st.Name AS SalesTerritoryName
FROM Sales.SalesPerson sp
INNER JOIN Person.Person p
    ON sp.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Sales.SalesTerritory st
    ON sp.TerritoryID = st.TerritoryID;
	
-- Task 4: Display employees currently working in the Purchasing department, along with their addresses
SELECT
    p.FirstName + ' ' + p.LastName AS EmployeeName
    , d.Name AS DepartmentName
    , a.AddressLine1
    , a.City
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeeDepartmentHistory edh
    ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN HumanResources.Department d
    ON edh.DepartmentID = d.DepartmentID
INNER JOIN Person.Person p
    ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN Person.BusinessEntityAddress bea
    ON p.BusinessEntityID = bea.BusinessEntityID
INNER JOIN Person.Address a
    ON bea.AddressID = a.AddressID
WHERE d.Name = 'Purchasing'
  AND edh.EndDate IS NULL;

-- Task 5: Display orders containing products from the Clothing category that were shipped to the United States
SELECT
    soh.SalesOrderID
    , p.Name AS ProductName
    , pc.Name AS CategoryName
    , cr.Name AS CountryName
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product p
    ON sod.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory pc
    ON ps.ProductCategoryID = pc.ProductCategoryID
INNER JOIN Person.Address a
    ON soh.ShipToAddressID = a.AddressID
INNER JOIN Person.StateProvince sp
    ON a.StateProvinceID = sp.StateProvinceID
INNER JOIN Person.CountryRegion cr
    ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE pc.Name = 'Clothing'
  AND cr.Name = 'United States';
