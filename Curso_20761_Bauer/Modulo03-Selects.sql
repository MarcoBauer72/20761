----- Modulo 3: Writing SELECT Queries

USE Adventureworks
GO

-- CAMPO CALCULADO
SELECT
	  SalesOrderID
	 ,productid
	-- ,unitprice
	-- ,OrderQty
	 ,(unitprice * OrderQty) 
FROM Sales.SalesOrderDetail
--ORDER BY TOTAL DESC


SELECT  COLOR 
FROM PRODUCTION.PRODUCT 
ORDER BY COLOR

-- DISTINCT

SELECT DISTINCT Color 
FROM PRODUCTION.PRODUCT
 






SELECT
	 DISTINCT COLOR
FROM Production.Product
WHERE COLOR IS NOT NULL



SELECT DISTINCT COLOR, LISTPRICE
FROM  Production.Product
WHERE COLOR = 'Yellow'


SELECT DISTINCT   COLOR, LISTPRICE , MakeFlag
FROM Production.Product
WHERE COLOR = 'Yellow'



-- APELIDOS ( ALIASES )
SELECT
	  SalesOrderID
	 ,productid
	 ,unitprice
	 ,OrderQty
	 ,(unitprice * OrderQty) AS 'SELECT'
FROM Sales.SalesOrderDetail;


SELECT
	  SalesOrderID
	 ,productid
	 ,unitprice
	 ,OrderQty
	 ,(unitprice * OrderQty) AS 'SUB TOTAL'
FROM Sales.SalesOrderDetail
WHERE (unitprice * OrderQty) > 30000
ORDER BY 'SUB TOTAL' DESC


SELECT
	  SalesOrderID
	 ,productid
	 ,unitprice
	 ,OrderQty
	 ,(unitprice * OrderQty) 
FROM Sales.SalesOrderDetail;


SELECT
	  SalesOrderID
	 ,productid
	 ,unitprice
	 ,OrderQty
	 ,(unitprice * OrderQty) 'FROM'
FROM Sales.SalesOrderDetail;


SELECT 
	 BusinessEntityID AS 'MEU CODIGO'
	,FirstName AS [PRIMEIRO NOME]
	,MiddleName AS NOMEMEIO
	,NOME = MiddleName 
	,LastName SOBRENOME
FROM Person.Person
ORDER BY BusinessEntityID


SELECT 
	 Productid
	,Name
	,StandardCost
	,'PRECO NOVO' = (StandardCost * 1.1) 
	,(StandardCost * 1.1) AS 'PRECO NOVO'
	,(StandardCost * 1.1) 'PRECO NOVO'
FROM Production.Product;


SELECT ProductID, Name, ProductNumber, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, Weight, DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate
FROM [Production].[Product]

-- CASE (SUBSTITUICAO)
SELECT
	 ProductID
	,Name	
--	,Color 
	,CASE Color
	   WHEN 'Black' THEN 'Preta'
	   WHEN 'Blue' THEN 'Azul'
	   WHEN 'Yellow' THEN 'Amarelo'
	   WHEN 'Silver' THEN 'Prata'
	   WHEN 'Red' THEN 'Vermelho'
	   WHEN 'White' THEN 'Branco'
	   WHEN 'Multi' THEN 'Multicolorido'
	   WHEN 'Grey' THEN 'Cinza'
	   WHEN 'Silver/Black' THEN 'Preto Metalico'
	   ELSE 'Cor nao definida'
	 END AS COR
FROM Production.Product
WHERE COLOR IS NOT NULL
 



-- EXPRESSIONS E VARIAVEL
DECLARE @COTACAO AS DECIMAL(4,2) 
SET @COTACAO  = 5.0 -- COTACAO DE UMA MOEDA QUALQUER <> REAL

SELECT ProductID
	,StandardCost AS [CUSTO EM DOLAR]
	,StandardCost * @COTACAO AS 'CUSTO EM REAIS' -- EXPRESSAO
	,ListPrice AS [VENDA EM DOLAR]
	,ListPrice * @COTACAO * 1.1 AS [VENDA EM REAIS] -- EXPRESSAO
FROM Production.Product
WHERE StandardCost <> 0 AND ListPrice <> 0



---------------------------------- COMANDO NOVO T-SQL 2012 ----------------------------------

-- Comando T-SQL2012 (CONCACT)

SELECT CONCAT('HOJE ESTAMOS NO DIA ', FORMAT(CONVERT(DATE,GETDATE()),'dd/MM/yyyy','pt-BR'))


SELECT
	 FirstName
	,MiddleName
	,LastName
	,FirstName + ' ' + MiddleName + ' ' + LastName AS 'NOME COMPLETO'
FROM Person.Person



SELECT 
     FirstName
	,MiddleName
	,LastName
    ,CONCAT(FirstName,' ',MiddleName,' ',LastName) AS Nome
FROM Person.Person


SELECT FirstName +  1 + LastName
FROM PERSON.PERSON

DECLARE @VAR AS CHAR(1) = '-'
SELECT
CONCAT(FirstName,1,MiddleName,@VAR,LastName) AS NC
FROM PERSON.PERSON



-- Lab. 3  - Página 84 ou Página 552
-- Exercícios (1,2,3 e 4) - 40 minutos

