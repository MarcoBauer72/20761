-- 12/05 - INICIAR AQUI

----- Modulo 11: Using Table Expressions
USE Adventureworks
GO

--DROP  TABLE Pessoas
-- VIEWS
CREATE TABLE Pessoas
(
   ID int
   ,TIPO nchar(2)
   ,NOME nvarchar(200)
)


truncate table Pessoas

INSERT INTO Pessoas 
SELECT
	 BusinessEntityID 
	,PersonType
	,CONCAT(firstName, ' ', LastName)
FROM Adventureworks.Person.PERSON 

SELECT * FROM PESSOAS

SP_HELPTEXT VW_PESSOAS_E

SELECT * FROM VW_PESSOAS_E

SELECT * FROM PESSOAS

DROP VIEW VW_PESSOAS_E

--WITH SCHEMABINDING

ALTER VIEW [VW_PESSOAS_E]
WITH SCHEMABINDING
AS 
SELECT  NOME AS NOMECOMPLETO
FROM DBO.Pessoas
WHERE NOME LIKE 'E%'
GO

SELECT * FROM VW_PESSOAS_E

SP_HELPTEXT VW_PESSOAS_E

SP_DEPENDS Pessoas


SELECT * FROM VW_PESSOAS_E



--with schemabinding

SP_HELPTEXT VW_PESSOAS_E


SELECT NOMECOMPLETO FROM VW_PESSOAS_E



SELECT * FROM PESSOAS


--DROP VIEW vw_Empregados_A

CREATE View vw_Empregados_A
AS
SELECT 
	BusinessEntityID
	,PersonType
	,FirstName + ' ' + LastName AS FullName
FROM PERSON.PERSON 
WHERE FirstName LIKE 'A%'

GO

SP_DEPENDS 'PERSON.PERSON'

SELECT * FROM vw_Empregados_A


drop view vw_Empregados_A

--DROP VIEW vw_PESSOAS_AN



ALTER VIEW vw_PESSOAS_AN
WITH SCHEMABINDING
AS
SELECT
	 ID
	,NAME
FROM dbo.PESSOAS
WHERE UPPER(NAME) LIKE 'AN%'


SP_HELPTEXT 'vw_PESSOAS_AN'

SELECT 
	  ID
	 ,NOME 
FROM vw_PESSOAS_AN

SP_DEPENDS PESSOAS

SELECT * FROM vw_PESSOAS_AN


SELECT * FROM PESSOAS

DROP VIEW vw_PESSOAS_B

UPDATE [dbo].[PESSOAS]
SET SALARIO = 1000

-- VIEWS COM SCHEMABINDING
ALTER VIEW vw_PESSOAS_B
AS
SELECT
	 ID
	,TYPE
	,NOMECOMPLETO
	,OBS
FROM dbo.Pessoas
WHERE NOMECOMPLETO LIKE 'B%'


SELECT * FROM vw_PESSOAS_B

SP_HELPTEXT vw_PESSOAS_B


--DROP VIEW vw_PESSOAS


-- REFRESH DA VIEW
EXEC sys.sp_refreshview @viewname = 'vw_PESSOAS_AN'
GO

DROP VIEW VW_PESSOAS

CREATE VIEW VW_PESSOAS
AS
(
SELECT * FROM PESSOAS
)

SELECT * FROM VW_PESSOAS

EXEC sys.sp_refreshview @viewname = 'vw_PESSOAS'
GO

SP_DEPENDS PESSOAS

SP_DEPENDS '[Production].[Product]'


SELECT * FROM VW_PESSOAS




DROP FUNCTION fn_CalculaJuros



-- FUNCAO ESCALAR
CREATE function fn_CalculaJuros(@valor decimal) 
returns decimal
begin
return (@valor) * 3
end


select dbo.fn_calculajuros(40)


select 
SubTotal as valor,
(subtotal*3) as juros,
subtotal + (subtotal*3) as total 
from sales.SalesOrderHeader 

select 
SubTotal as valor,
dbo.fn_calculajuros(subtotal) as juros,
subtotal + dbo.fn_calculajuros(subtotal) as total 
from sales.SalesOrderHeader 

DROP FUNCTION fn_sel_empregados

-- FUNCAO TABULAR
CREATE function fn_sel_empregados
(@valor1 int, @valor2 int) 
returns table
return (
select  
 e.BusinessEntityID codigo,
 e.Gender sexo,
 e.MaritalStatus as EstadoCivil,
 Year(e.BirthDate) AnoNascimento,
 e.JobTitle Cargo
 from HumanResources.Employee e 
where e.BusinessEntityID between @valor1 and @valor2 
)


SELECT 
 codigo
 ,sexo
FROM [dbo].[fn_sel_empregados] (22,9)






declare @a int = 14

select * from dbo.fn_sel_empregados(10, iif(@a <10,20,@a))



--DERIVED TABLES E CTE COMMON TABLE EXPRESSION
-- Subquery retorna mais de 1 valor
USE TSQL
GO

SELECT 
	 orderid AS idpedido
	,productid AS idproduto
	,unitprice AS precounitario
	,qty AS qtde
FROM Sales.OrderDetails
WHERE orderid IN 
	(SELECT orderid AS O
	FROM Sales.Orders
	WHERE empid =2);

-- CTE???
WITH ABC (idpedido,idproduto,precounitario,qtde) 
AS
(
	SELECT 
		 orderid 
		,productid 
		,unitprice 
		,qty
	FROM Sales.OrderDetails 
)
SELECT 
	 idpedido,idproduto,precounitario,qtde
FROM ABC AS A
JOIN sales.Orders AS O
ON A.idpedido = O.orderid
WHERE O.empid = 2














WITH ABOBRINHA (idpedido,idproduto,precounitario,qtde)
AS
(
SELECT 
	 orderid 
	,productid 
	,unitprice
	,qty
FROM Sales.OrderDetails
)
SELECT 
	 idpedido
	,idproduto
	,precounitario
	,qtde
FROM ABOBRINHA
JOIN Sales.Orders AS XUXU
ON ABOBRINHA.idpedido = XUXU.orderid
WHERE XUXU.empid =2





WITH TABELA (idpedido, idproduto, precounitario, qtde)
AS
(
SELECT SalesOrderID, productid, unitprice, OrderQty
FROM Sales.SalesOrderDetail 
)
SELECT * FROM TABELA
JOIN Sales.SalesOrderHeader AS O
ON TABELA.idpedido = O.SalesOrderID WHERE O.SalesPersonID =290

--SELECT SalesPersonID FROM  Sales.SalesOrderHeader AS O
--ORDER BY SalesPersonID DESC




--
USE Adventureworks
GO



SELECT  ANO
	   ,COUNT(CLIENTE) AS cust_count
	   ,COUNT(DISTINCT CLIENTE) AS cust_dist
FROM
(	
	SELECT  YEAR(orderdate), CustomerID
	FROM Sales.SalesOrderHeader  
	WHERE SalesPersonID= 290
) AS derived_year(ANO,CLIENTE)
GROUP BY ANO;





WITH CUST_290 (ANO, CLIENTE)
AS
(
	SELECT  YEAR(orderdate), CustomerID
	FROM Sales.SalesOrderHeader  
	WHERE SalesPersonID= 290
)
SELECT 
	  ANO
     ,COUNT(CLIENTE) AS cust_count
	 ,COUNT(DISTINCT CLIENTE) AS cust_dist
FROM CUST_290
GROUP BY ANO








-- COM CTE
;WITH VENDA_ANO (ANO, CLIENTE)
AS
(	-- SELECT ANCORA
	SELECT  YEAR(orderdate) AS orderyear, CustomerID
	FROM Sales.SalesOrderHeader  
	WHERE SalesPersonID= 290
)
SELECT ANO, COUNT(DISTINCT(CLIENTE)) AS CONTAGEM
FROM VENDA_ANO
GROUP BY ANO







USE AdventureWorks
GO


--SET STATISTICS IO ON;
--GO

WITH UpperHierarchy(EmpID, Employee, Manager, HierarchyOrder)
 AS
 (
    SELECT emp.EmployeeID, emp.LoginID, emp.LoginID, 1 AS HierarchyOrder
    FROM HumanResources.Employee AS emp
      WHERE emp.ManagerID is Null
    UNION ALL
    SELECT emp.EmployeeID,  emp.LoginID, Parent.Employee, HierarchyOrder + 1
    FROM HumanResources.Employee AS emp
           INNER JOIN UpperHierarchy AS Parent
                 ON emp.ManagerID = Parent.EmpID
 )
 SELECT *
 From UpperHierarchy

--SET STATISTICS IO OFF;
--GO
 
SELECT ManagerID, * FROM [HumanResources].[Employee]
WHERE EmployeeID = 109

SELECT ManagerID, * FROM [HumanResources].[Employee]
WHERE EmployeeID = 6


SELECT ManagerID, * FROM [HumanResources].[Employee]
WHERE EmployeeID = 273


SELECT ManagerID, * FROM [HumanResources].[Employee]
WHERE EmployeeID = 268






USE Adventureworks
GO


WITH TopSales (VENDEDOR, QTDE_VENDAS) AS
(
	SELECT 
		 SalesPersonID  
		,Count(*)  
	FROM Sales.SalesOrderHeader 
	WHERE SalesPersonId IS NOT NULL
	GROUP BY SalesPersonId
)
SELECT 
     TOP (5)
	 T.VENDEDOR
	,T.QTDE_VENDAS
FROM TopSales AS T 
ORDER BY T.QTDE_VENDAS DESC
;WITH WorstSales (VENDEDOR, QTDE_VENDAS) AS
(
	SELECT 
		 SalesPersonID  
		,Count(*)  
	FROM Sales.SalesOrderHeader 
	WHERE SalesPersonId IS NOT NULL
	GROUP BY SalesPersonId
)
SELECT 
     TOP (5)
	 T.VENDEDOR
	,T.QTDE_VENDAS
FROM WorstSales AS T 
ORDER BY T.QTDE_VENDAS ASC







;WITH WorstSales (VENDEDOR, QTDE_VENDAS) AS
(
	SELECT 
		 SalesPersonID  
		,Count(*)  
	FROM Sales.SalesOrderHeader 
	WHERE SalesPersonId IS NOT NULL
	GROUP BY SalesPersonId
)
SELECT 
     TOP (5)
	 T.VENDEDOR
	,T.QTDE_VENDAS
	,E.BirthDate
	,concat(p.FirstName,' ',p.LastName) as nome_vendedor
FROM [HumanResources].[Employee] AS E
	INNER JOIN WorstSales AS T 
ON T.VENDEDOR = E.BusinessEntityID
	INNER JOIN Person.Person AS P
ON E.BusinessEntityID = P.BusinessEntityID
ORDER BY T.QTDE_VENDAS ASC


SELECT COUNT(*) FROM Sales.SalesOrderHeader
SELECT COUNT(*) FROM Sales.SalesOrderDetail

-- JOIN RETORNANDO APENAS 1 LINHA DO DETALHE
SELECT 
  	 D.SalesOrderID 
	,D.SalesOrderDetailID
	,D.ProductID
	,D.UnitPrice 
	,D.LineTotal
	,D.OrderQty
	,H.*
FROM Sales.SalesOrderDetail D
JOIN Sales.SalesOrderHeader H
ON H.SalesOrderID = D.SalesOrderID
WHERE D.SalesOrderID =  43661
--ORDER BY D.LineTotal DESC


-- RETORNANDO APENAS 1 LINHA DA TABELA DETALHE (ROW_NUMBER)
WITH ABACATE (ROWNUMBER, ID, DETAILID, UNITPRICE, TOTAL, PRODUTO) AS
(
 SELECT 
  ROW_NUMBER() OVER(PARTITION BY D.SalesOrderID   ORDER BY D.LineTotal DESC )
  AS RowNumber 
 ,D.SALESORDERID
 ,D.SalesOrderDetailID
 ,D.UnitPrice
 ,D.LineTotal
 ,D.ProductID
  FROM Sales.SalesOrderDetail D
)
SELECT * FROM ABACATE
WHERE ROWNUMBER = 1
ORDER BY ID



-- RETORNANDO APENAS 1 LINHA DA TABELA DETALHE (CROSS APPLY)
SELECT 
	 H.SalesOrderID
	,TopOne.SalesOrderID
	,TopOne.SalesOrderDetailID
	,TopOne.UnitPrice
	,TopOne.LineTotal
	,TopOne.ProductID
FROM Sales.SalesOrderHeader AS H
CROSS APPLY
	(
		SELECT TOP 1
			 SalesOrderDetailID 
			,SalesOrderID
			,UnitPrice
			,LineTotal
			,ProductID
		FROM Sales.SalesOrderDetail AS D
		WHERE H.SalesOrderID = D.SalesOrderID
		ORDER BY D.LineTotal DESC
	) AS TopOne
ORDER BY H.SalesOrderID



CREATE TABLE ##PRODUTOS
(
	ID INT
	,NOME VARCHAR(50)
)

INSERT INTO ##PRODUTOS 
VALUES (1,'MOUSE'),(2,'TECLADO'),(3,'MONITOR'),(4,'MOUSE'),(5,'TECLADO'),(6,'MOUSE')


;WITH MOUSE_PORCENTAGEM (TOTAL, MOUSE, TECLADO)
AS
(
  SELECT COUNT(*) AS TOTAL
  ,(SELECT COUNT(*) FROM ##PRODUTOS WHERE NOME = 'MOUSE')
  ,(SELECT COUNT(*) FROM ##PRODUTOS WHERE NOME = 'TECLADO')
  FROM ##PRODUTOS 
)
SELECT CONVERT(DECIMAL(5,2), MOUSE) / CONVERT(DECIMAL(5,2), TOTAL) * 100 AS MOUSES
,CONVERT(DECIMAL(5,2), TECLADO) / CONVERT(DECIMAL(5,2), TOTAL) * 100  AS TECLADOS
FROM MOUSE_PORCENTAGEM
;
WITH MOUSE_PORCENTAGEM2 (TOTAL, MOUSE, TECLADO)
AS
(
  SELECT COUNT(*) AS TOTAL
  ,(SELECT COUNT(*) FROM ##PRODUTOS WHERE NOME = 'MOUSE')
  ,(SELECT COUNT(*) FROM ##PRODUTOS WHERE NOME = 'TECLADO')
  FROM ##PRODUTOS 
)
SELECT CONVERT(DECIMAL(5,2), MOUSE) / CONVERT(DECIMAL(5,2), TOTAL) * 100 AS MOUSES
,CONVERT(DECIMAL(5,2), TECLADO) / CONVERT(DECIMAL(5,2), TOTAL) * 100  AS TECLADOS
FROM MOUSE_PORCENTAGEM2


-- Lab. 11 - Página 397 ou 743
-- Pg.49_Part2 ou Pg.331_Part2
-- Exercícios 1,2,3 e 4 - 60 minutos


