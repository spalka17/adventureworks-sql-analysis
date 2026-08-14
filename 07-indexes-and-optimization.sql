-- Task 1: LIKE wildcard and index usage
-- Goal: Compare LIKE 'Bike%' with LIKE '%Bike%' and check how wildcard position affects index usage.
-- Execution plan screenshot:
-- images/index-task-01-like-wildcard.png

CREATE NONCLUSTERED INDEX IX_SalesStore_Name
ON Sales.Store(Name);
GO

-- Version 1: known text prefix
-- Result: Index Seek
SELECT
    s.BusinessEntityID
    , s.Name
FROM Sales.Store s
WHERE s.Name LIKE 'Bike%';

-- Version 2: wildcard at the beginning
-- Result: Index Scan
SELECT
    s.BusinessEntityID
    , s.Name
FROM Sales.Store s
WHERE s.Name LIKE '%Bike%';


-- Task 2: Function on column vs date range
-- Goal: Compare filtering dates with MONTH()/YEAR() and with a SARGable date range.
-- Execution plan screenshot:
-- images/index-task-02-date-range.png

CREATE NONCLUSTERED INDEX IX_PurchaseOrderDetail_DueDate
ON Purchasing.PurchaseOrderDetail(DueDate);
GO

-- Version 1: function on column
-- Result: Index Scan
SELECT
    pod.PurchaseOrderID
    , pod.PurchaseOrderDetailID
    , pod.DueDate
FROM Purchasing.PurchaseOrderDetail pod
WHERE MONTH(pod.DueDate) = 3
  AND YEAR(pod.DueDate) = 2014;

-- Version 2: date range
-- Result: Index Seek
SELECT
    pod.PurchaseOrderID
    , pod.PurchaseOrderDetailID
    , pod.DueDate
FROM Purchasing.PurchaseOrderDetail pod
WHERE pod.DueDate >= '2014-03-01'
  AND pod.DueDate < '2014-04-01';


-- Task 3: Currency conversion and index usage
-- Goal: Find purchase order details where LineTotal converted to PLN exceeds 1000 PLN.
-- Exchange rate used: 1 unit = 4.2 PLN.
-- Compare calculation on the column with calculation on the value.
-- Execution plan screenshot:
-- images/index-task-03-pln-conversion.png

CREATE NONCLUSTERED INDEX IX_PurchaseOrderDetail_LineTotal
ON Purchasing.PurchaseOrderDetail(LineTotal);
GO

-- Version 1: calculation on column
-- Result: Index Scan
SELECT
    pod.PurchaseOrderID
    , pod.PurchaseOrderDetailID
    , pod.LineTotal
FROM Purchasing.PurchaseOrderDetail pod
WHERE pod.LineTotal * 4.2 > 1000;

-- Version 2: calculation on value
-- Result: Index Seek
SELECT
    pod.PurchaseOrderID
    , pod.PurchaseOrderDetailID
    , pod.LineTotal
FROM Purchasing.PurchaseOrderDetail pod
WHERE pod.LineTotal > 1000 / 4.2;


-- Task 4: Composite index and column order
-- Goal: Create a composite index on LastName and FirstName, then compare filtering by both columns, by LastName only, and by FirstName only.
-- Execution plan screenshot:
-- images/index-task-04-composite-index.png

CREATE NONCLUSTERED INDEX IX_Person_LastName_FirstName
ON Person.Person(LastName, FirstName);
GO

-- Version 1: filter by both indexed columns
-- Result: Index Seek
SELECT
    p.LastName
    , p.FirstName
FROM Person.Person p
WHERE p.LastName = 'Smith'
  AND p.FirstName = 'John';

-- Version 2: filter by the leading column
-- Result: Index Seek
SELECT
    p.LastName
    , p.FirstName
FROM Person.Person p
WHERE p.LastName = 'Smith';

-- Version 3: filter by the second column only
-- Result: Index Scan
SELECT
    p.LastName
    , p.FirstName
FROM Person.Person p
WHERE p.FirstName = 'John';


-- Task 5: Selectivity and index usage
-- Goal: Compare a narrow filter with a broad filter on the same indexed column.
-- Execution plan screenshot:
-- images/index-task-05-selectivity.png

CREATE NONCLUSTERED INDEX IX_PurchaseOrderHeader_TotalDue
ON Purchasing.PurchaseOrderHeader(TotalDue);
GO

-- Version 1: narrow result set
-- Result: Index Seek
SELECT
    poh.PurchaseOrderID
    , poh.TotalDue
FROM Purchasing.PurchaseOrderHeader poh
WHERE poh.TotalDue > 20000;

-- Version 2: broad result set
-- Result: Index Seek with higher cost
SELECT
    poh.PurchaseOrderID
    , poh.TotalDue
FROM Purchasing.PurchaseOrderHeader poh
WHERE poh.TotalDue > 1;
