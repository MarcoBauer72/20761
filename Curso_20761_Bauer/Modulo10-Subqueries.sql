----- Modulo 10: Using Subqueries
USE Adventureworks
GO

-- QUERY INTERNA NAO RELACIONADA COM A EXTERNA    
SELECT ProductID, Name, color
FROM Production.Product
WHERE Color IN
	(
		SELECT Color
		FROM Production.Product
		WHERE ProductID IN (317, 320, 935)
	)
------------------------------------------------------------------------------





SELECT  ProductID
		, Name
		, ProductNumber
		, MakeFlag
		, FinishedGoodsFlag
		, Color
		, SafetyStockLevel
FROM Production.Product AS P
WHERE EXISTS
(
SELECT ProductSubcategoryID FROM Production.ProductSubcategory AS S
WHERE S.Name = 'Wheels' 
and
P.ProductSubcategoryID = S.ProductSubcategoryID
) 

SELECT P.ProductID
	,P.Name
	,P.ProductNumber
	,P.MakeFlag
	,P.FinishedGoodsFlag
	,P.Color
	,P.SafetyStockLevel
FROM Production.Product AS P
INNER JOIN Production.ProductSubcategory AS S
ON P.ProductSubcategoryID = S.ProductSubcategoryID
WHERE S.Name = 'Wheels' 





















SELECT  ProductID
		, P.Name
		, ProductNumber
		, MakeFlag
		, FinishedGoodsFlag
		, Color
		, SafetyStockLevel
FROM Production.Product AS P
JOIN Production.ProductSubcategory AS S
ON P.ProductSubcategoryID = S.ProductSubcategoryID
WHERE S.Name = 'Wheels'

SELECT  ProductID
		, P.Name
		, ProductNumber
		, MakeFlag
		, FinishedGoodsFlag
		, Color
		, SafetyStockLevel
FROM Production.Product AS P
JOIN Production.ProductSubcategory AS S
ON P.ProductSubcategoryID = S.ProductSubcategoryID
WHERE S.Name = 'Wheels'










-- COM JOIN?

SELECT  ProductID
		, P.Name AS PRODUTO
		, S.Name AS SUBCAT
		, ProductNumber
		, MakeFlag
		, FinishedGoodsFlag
		, Color
		, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, Weight, DaysToManufacture, ProductLine, Class, Style, P.ProductSubcategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, P.rowguid, P.ModifiedDate
		
FROM Production.Product AS P
JOIN Production.ProductSubcategory AS S
ON P.ProductSubcategoryID = S.ProductSubcategoryID
WHERE S.Name = 'Wheels'










-- COM JOIN
SELECT  ProductID, P.Name, ProductNumber, MakeFlag, FinishedGoodsFlag
FROM Production.Product AS P
JOIN Production.ProductSubcategory AS S
ON P.ProductSubcategoryID = s.ProductSubcategoryID
WHERE S.Name = 'Wheels'
------------------------------------------------------------------------------

-- SubQuery nao Correlacionada com a externa
SELECT * FROM Production.Product AS P
WHERE EXISTS
    (
	 SELECT * FROM Production.ProductSubcategory AS PS
     WHERE PS.Name = 'Wheels'
	)
 

-- SubQueries Correlacionadas: QUERY INTERNA CORRELACIONADA COM A EXTERNA         
SELECT * FROM Production.Product AS P
WHERE EXISTS
    (
	 SELECT * FROM Production.ProductSubcategory AS PS
     WHERE PS.Name = 'Wheels'
     AND P.ProductSubcategoryID = PS.ProductSubcategoryID
	)
------------------------------------------------------------------------------

  
-- Correlated subqueries are executed repeatedly, 
-- once for each row that may be selected by the outer query
SELECT
	 c.BusinessEntityID	
	,c.FirstName
	,c.LastName
	,CONCAT(c.FirstName, ' ' , c.LastName) AS Nome
	,e.JobTitle
FROM Person.Person c 
INNER JOIN HumanResources.Employee e
ON c.BusinessEntityID = e.BusinessEntityID 
WHERE 
(   
	SELECT Bonus
	FROM Sales.SalesPerson sp
	WHERE e.BusinessEntityID = sp.BusinessEntityID
) <1000
 
 --SELECT *
	--FROM Sales.SalesPerson sp
	--WHERE BONUS < 1000



SELECT *
	FROM Sales.SalesPerson sp
WHERE  Bonus > 1000  -- 279, 286, 289
--275
--279
--280
--282
--286
--289

-- Subquery retorna mais de 1 valor
SELECT 
	 SalesOrderID
	,productid
	,unitprice
	,OrderQty
FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN
	(SELECT SalesOrderID AS O
	FROM Sales.SalesOrderHeader
	WHERE SalesPersonID =290);


SELECT 
	 SD.SalesOrderID
	,productid
	,unitprice
	,OrderQty
FROM Sales.SalesOrderDetail AS SD
JOIN Sales.SalesOrderHeader AS H
ON SD.SalesOrderID = H.SalesOrderID
WHERE SalesPersonID =290


-- Retorna o pedido mais recente
SELECT MAX(orderid) AS lastorder
FROM Sales.Orders;



	-- Itens do pedido mais recente
	SELECT 
		 orderid
		,productid
		,unitprice
		,qty
		,(qty * unitprice) as SUBTOTAL
	FROM 
		Sales.SalesOrderDetail
	WHERE orderid = 
		(SELECT MAX(orderid) AS lastorder
		FROM Sales.Orders);







USE Adventureworks 
GO

-- Subqueries multivaloradas
SELECT *
FROM Sales.Customer AS C
WHERE NOT EXISTS
(
SELECT CustomerID
FROM Sales.SalesOrderHeader AS SO
WHERE C.CustomerID = SO.CustomerID
)

SELECT
C.*
FROM Sales.Customer AS C
LEFT JOIN Sales.SalesOrderHeader AS SO
ON C.CustomerID = SO.CustomerID
WHERE SO.CustomerID IS NULL









SELECT SO.CustomerID, SalesOrderID
FROM Sales.SalesOrderHeader AS SO
JOIN Sales.Customer AS C
ON SO.CustomerID = C.CustomerID
AND C.[TerritoryID] = 1


SELECT SO.CustomerID, SalesOrderID
FROM Sales.SalesOrderHeader AS SO
JOIN Sales.Customer AS C
ON SO.CustomerID = C.CustomerID
WHERE C.[TerritoryID] = 1









-- COM JOIN???
SELECT SOH.CustomerID, SalesOrderID
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.Customer AS C
ON SOH.CustomerID = C.CustomerID
WHERE C.TerritoryID = 1;



















-- O mesmo resultado anterior porem com JOIN
SELECT 
	 SO.CustomerID
	,SO.SalesOrderID
FROM Sales.SalesOrderHeader AS SO
INNER JOIN Sales.Customer AS C
ON SO.CustomerID = C.CustomerID
WHERE C.[TerritoryID] = 1






SELECT 
	 c.custid
	,o.orderid
FROM
	Sales.Orders AS o 
JOIN 
	Sales.Customers AS c 
ON o.custid = c.custid
WHERE c.country = N'Mexico';



-- Lab. 10 - Página 360 ou 735 (PDF)
-- Exercícios (1,2 e 3) - 70 minutos
