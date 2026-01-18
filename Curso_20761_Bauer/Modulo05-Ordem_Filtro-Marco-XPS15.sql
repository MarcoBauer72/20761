----- Modulo 5: Sorting and Filtering Data

USE Adventureworks2014
GO


----- ORDER BY
SELECT 
	 orderid
	,custid
	,orderdate
FROM 
	Sales.Orders
ORDER BY orderdate desc


SELECT orderid, custid, YEAR(orderdate) AS ANO
FROM Sales.Orders
ORDER BY ANO DESC;

SELECT orderid, custid, orderdate
FROM Sales.Orders
ORDER BY orderdate;


select  * from [Person].[Person]
where MiddleName IS NOT  null
order by FirstName, LastName desc 



SELECT COUNT(*) FROM Person.Person


----- WHERE 
SELECT orderid, custid, YEAR(orderdate) AS ordyear
FROM Sales.Orders
WHERE YEAR(orderdate) = '2006' OR YEAR(orderdate) = '2007' OR YEAR(orderdate) = '2008';




SELECT orderid, custid, YEAR(orderdate) AS ordyear
FROM Sales.Orders
WHERE YEAR(orderdate) IN ('2006','2007','2008');





SELECT orderid, custid, YEAR(orderdate) AS ANO
FROM Sales.Orders
WHERE YEAR(orderdate) NOT IN ('2006','2007')
ORDER BY ANO DESC 


SELECT contactname, country
FROM Sales.Customers
WHERE country = 'SPAIN';


SELECT orderid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20070101';


SELECT custid, companyname, country
FROM Sales.Customers
WHERE country = N'UK' OR country = N'Spain';


SELECT custid, companyname, country
FROM Sales.Customers
WHERE country IN (N'UK',N'Spain');

SELECT custid, companyname, country
FROM Sales.Customers
WHERE country NOT IN (N'UK',N'Spain');


SELECT orderid, custid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20061231' AND orderdate <= '20080101';




SELECT orderid, custid, orderdate
FROM Sales.Orders
WHERE orderdate BETWEEN '20061231' AND '20080101';


SELECT
*
FROM
Production.Product
WHERE ProductID BETWEEN 300 AND 400


SELECT
*
FROM
Production.Product
WHERE ProductID >= 300 AND  ProductID <= 400



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
FROM Production.Product
WHERE COLOR IN ('Blue', 'Black','Yellow','White','LARANJA')


-- LIKE
SELECT
*
FROM
Production.Product
WHERE COLOR LIKE '%K'



----- TOP TIES , OFFSET-FETCH

-- 10 mais recentes pedidos. Ignora linhas com datas duplicadas
SELECT TOP 10 orderid, custid, orderdate
FROM Sales.Orders
ORDER BY orderdate DESC;



-- 5 mais recentes pedidos. Retorna datas duplicadas de pedido 
SELECT TOP (5) WITH TIES orderid, custid, orderdate
FROM Sales.Orders
ORDER BY orderdate DESC;


-- COMANDO NOVO T-SQL 2012
-- Somente as primeiras 50 linhas como TOP (50)
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
ORDER BY orderid ASC
OFFSET 0 ROWS FETCH FIRST 50 ROWS ONLY;


-- COMANDO NOVO T-SQL 2012
-- Pula as 100 primeiras linhas e retorna da 101 a 200
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
ORDER BY orderid ASC 
OFFSET 12 ROWS FETCH NEXT 50 ROWS ONLY;



----- Filtrando por NULL
SELECT COUNT(*) FROM Production.Product

SELECT * 
FROM Production.Product 
WHERE COLOR IS NOT NULL


SELECT 
	 FirstName
	,MiddleName
	,LastName
    ,(ISNULL(FirstName,'') + ISNULL(MiddleName,'') + ISNULL(LastName,'')) AS NOMECOMPLETO
	,CONCAT(FirstName,MiddleName,LastName) AS CONCATNOMECOMPLETO
FROM Person.Person


-- Modulo 8: ISNULL, NULLIF, COALESCE


-- UNICODE

-- ?????

create table #unicodeinsert (valor nvarchar(max))

insert into #unicodeinsert values (N'?????')

insert into #unicodeinsert values ('?????')

select * from #unicodeinsert


-- Lab. 6 - P?gina 213 ou 697 (PDF)
-- Exerc?cios (1,2,3 e 4) - 60 minutos
