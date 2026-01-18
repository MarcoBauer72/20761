----- Modulo 5: Sorting and Filtering Data

USE AdventureWorks;
GO


----- ORDER BY (Evitar rodar do lado Server)
----- Trazer desordenado para o CLIENT e ordernar em memoria
SELECT 
	 orderid
	,custid
	,orderdate
FROM 
	TSQL.Sales.Orders
ORDER BY orderdate


SELECT 
	 SalesOrderID
	,CustomerID
	,YEAR(orderdate) AS ANO
FROM Sales.SalesOrderHeader
ORDER BY ANO DESC, CustomerID ASC,SalesOrderID DESC  


SELECT  * 
FROM [Person].[Person]
ORDER BY FirstName, LastName, MiddleName DESC


SELECT COUNT(Color) FROM Production.Product


----- WHERE 
SELECT orderid
	,custid
	,YEAR(orderdate) AS ordyear
FROM TSQL.Sales.Orders
WHERE YEAR(orderdate) IN (2006,2008)



SELECT orderid, custid, YEAR(orderdate) AS ordyear
FROM TSQL.Sales.Orders
WHERE YEAR(orderdate) = '2006' OR YEAR(orderdate) = '2008'


SELECT orderid, custid, YEAR(orderdate) AS ordyear
FROM TSQL.Sales.Orders
WHERE YEAR(orderdate) IN ('2006','2007');


SELECT orderid, custid, YEAR(orderdate) AS ordyear
FROM TSQL.Sales.Orders
WHERE YEAR(orderdate) >=2006 AND YEAR(orderdate)<2008


SELECT orderid, custid, YEAR(orderdate) AS ordyear
FROM TSQL.Sales.Orders
WHERE YEAR(orderdate) BETWEEN '2006' AND '2007'

SELECT orderid, custid, YEAR(orderdate) AS ANO
FROM TSQL.Sales.Orders
WHERE YEAR(orderdate) NOT IN ('2006','2007')
ORDER BY ANO DESC 




SELECT contactname, country
FROM TSQL.Sales.Customers --91 linhas
WHERE country = 'SPAIN';


SELECT orderid, orderdate
FROM TSQL.Sales.Orders
WHERE orderdate >= '20070101';


SELECT custid, companyname, country
FROM TSQL.Sales.Customers
WHERE country = N'UK' OR country = N'SPAIN' 


SELECT custid, companyname, country
FROM TSQL.Sales.Customers
WHERE country IN (N'UK',N'Spain',N'France');

SELECT custid, companyname, country
FROM TSQL.Sales.Customers
WHERE country NOT IN (N'UK',N'Spain');


SELECT orderid, custid, orderdate
FROM TSQL.Sales.Orders
WHERE orderdate >= '20061231' AND orderdate <= '20080101';




SELECT orderid, custid, orderdate
FROM TSQL.Sales.Orders
WHERE orderdate BETWEEN '20061231' AND '20080101';


SELECT
*
FROM
Adventureworks.Production.Product
WHERE ProductID BETWEEN 300 AND 400


SELECT
*
FROM
Adventureworks.Production.Product
WHERE ProductID >= 300 AND  ProductID <= 400

SELECT
*
FROM
Production.Product
WHERE ProductID BETWEEN 300 AND 400

SELECT 
	 FirstName
	,MiddleName
	,LastName
	,BusinessEntityID
	,ModifiedDate
FROM Person.Person
WHERE ModifiedDate BETWEEN '01/01/2000' AND '01/01/2002'
ORDER BY ModifiedDate DESC

SELECT
 	 ProductID
	,Name
	,Color
	,StandardCost
	,ListPrice	
FROM Adventureworks.Production.Product
WHERE COLOR IN ('Blue', 'Black','Yellow','White','LARANJA')


-- LIKE
SELECT
NAME, COLOR
FROM
Production.Product
WHERE COLOR LIKE 'B____'



----- TOP TIES , OFFSET-FETCH

-- Pedidos mais recentes. Ignora linhas com datas duplicadas
SELECT TOP 10 orderid
	,custid
	,orderdate
FROM TSQL.Sales.Orders
ORDER BY orderdate DESC;



-- Pedidos recentes. Retorna datas duplicadas de pedido 
SELECT TOP 5
WITH TIES orderid
	,custid
	,orderdate
FROM TSQL.Sales.Orders
ORDER BY orderdate DESC;


-- 10248 ATEH 10297 (50 PEDIDOS)
-- COMANDO NOVO T-SQL 2012
-- Somente as primeiras 50 linhas como TOP (50)
SELECT orderid, custid, empid, orderdate
FROM TSQL.Sales.Orders
ORDER BY orderid ASC
OFFSET 0 ROWS FETCH FIRST 50 ROWS ONLY;


-- COMANDO NOVO T-SQL 2012
-- Pula as 100 primeiras linhas e retorna da 101 a 200
SELECT orderid, custid, empid, orderdate
FROM TSQL.Sales.Orders
ORDER BY orderid ASC 
OFFSET 10 ROWS FETCH NEXT 20 ROWS ONLY;


SELECT orderid, custid, empid, orderdate
FROM TSQL.Sales.Orders
ORDER BY orderid ASC 
OFFSET 12 ROWS FETCH NEXT 50 ROWS ONLY;


-- PULA AS 10 PRIMEIRAS LINHAS E RETORNA O RESTO DAS LINHAS
SELECT orderid, custid
FROM TSQL.Sales.Orders
ORDER BY orderid 
OFFSET 30 ROWS;

-- 504 (256 COM COR)
----- Filtrando por NULL
SELECT COUNT(COLOR) 
FROM Production.Product -- 504
-- 256 PRODUTOS COM COR
-- 248 PRODUTOS SEM COR (NULL)

SELECT COLOR,*
FROM 
Adventureworks.Production.Product 
WHERE COLOR IS NOT NULL


SELECT * 
FROM 
Adventureworks.Production.Product 
WHERE COLOR IS NOT NULL


-- NULL = DESCONHECIDO

SELECT COUNT(*) FROM Production.Product




-- Modulo 8: ISNULL, NULLIF, COALESCE


-- UNICODE

-- ?????
--DROP TABLE #unicodeinsert

create table #unicodeinsert (valor nvarchar(10))

insert #unicodeinsert values (N'??????')

insert #unicodeinsert values ('??????')

select * from #unicodeinsert


-- Lab. 5 - Pagina 213 ou 463 (PDF)
-- Exercicios (1,2,3 e 4) - 60 minutos
