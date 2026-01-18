----- Modulo 4: Querying Multiple Tables

USE Adventureworks
GO
	

------- MOTIVACAO 1 :  RETORNAR LINHAS EM COMUM E/OU DISTINTAS 
-------(INTERSECCAO,UNIAO,...)
BEGIN TRY
	DROP TABLE  PESSOAS
	DROP TABLE  CLIENTES
END TRY
BEGIN CATCH 
 PRINT 'Tabelas nao existem!'
END CATCH

CREATE TABLE PESSOAS
( 
ID INT PRIMARY KEY
,NOME VARCHAR(100)
,EMAIL VARCHAR(100)
)

CREATE TABLE CLIENTES
(
ID_CLIENTE INT
,ID_PESSOA INT
,NOME VARCHAR(100)
,EMAIL VARCHAR(100)
,ATIVO BIT DEFAULT 1
)

SELECT * FROM PESSOAS


SELECT * FROM CLIENTES


------- MOTIVACAO 2 :  RETORNAR CAMPOS DE TABELAS DIFERENTES
-- APAGA AS TABELAS DO EXEMPLO CASO EXISTAM
BEGIN TRY
	DROP TABLE  PRODUTOS
	DROP TABLE  VENDAS
END TRY
BEGIN CATCH
	 PRINT 'Tabelas nao existem!'
END CATCH

SET LANGUAGE ENGLISH
PRINT 1/0

CREATE TABLE PRODUTOS
(
  ID INT UNIQUE NOT NULL
 ,NOME VARCHAR(50) NOT NULL
 ,PRECO NUMERIC(8,2) 
)
GO

INSERT PRODUTOS VALUES (1,'MOUSE',15.00),(2,'TECLADO',20.00),(3,'MONITOR LED',380.00),(4,'ESTABILIZADOR',35.00)



SELECT * FROM PRODUTOS


CREATE TABLE VENDAS
( 
   ID_VENDA INT NOT NULL
  ,ID_PRODUTO INT NOT NULL
  ,QUANTIDADE INT NOT NULL
)
GO

INSERT INTO VENDAS VALUES (1,2,2),(2,1,3)

SELECT * FROM PRODUTOS

SELECT * FROM VENDAS


-- REQUISAO: NUM.VENDA, IDPRODUTO, QTDVENDA
--          ,NOMEPRODUTO, PRECOUNIT, SUBTOTAL


-- VENDA DE PRODUTO INEXISTENTE
INSERT VENDAS VALUES (3,11,100)

--INSERT INTO VENDAS VALUES (4,2,20)


-- CROSS JOIN (Cuidado com este tipo de JOIN !!!)

SELECT
	*
FROM VENDAS V, PRODUTOS P


SELECT
	*
FROM VENDAS V
CROSS JOIN PRODUTOS P




-- INNER JOIN ou apenas JOIN (Linhas em Comum)
SELECT 
	   V.ID_VENDA
	  ,V.ID_PRODUTO
	  ,P.NOME
	  ,P.PRECO
	  ,V.QUANTIDADE
	  ,(P.PRECO * V.QUANTIDADE) AS TOTAL
FROM VENDAS AS V
INNER JOIN PRODUTOS AS P
ON V.ID_PRODUTO = P.ID 




-- RIGHT JOIN ou RIGHT OUTER JOIN
SELECT 
	   V.ID_VENDA
	  ,V.ID_PRODUTO
	  ,P.ID
	  ,P.NOME
	  ,P.PRECO
	  ,V.QUANTIDADE
	  ,(P.PRECO * V.QUANTIDADE) AS TOTAL
FROM VENDAS AS V
LEFT JOIN PRODUTOS AS P
ON V.ID_PRODUTO = P.ID
WHERE P.ID IS NULL



-- RIGHT JOIN EXCLUSIVO (SEM LINHAS EM COMUM)
SELECT 
	   V.ID_VENDA
	  ,V.ID_PRODUTO
	  ,P.ID
	  ,P.NOME
	  ,P.PRECO
	  ,V.QUANTIDADE
	  ,(P.PRECO * V.QUANTIDADE) AS TOTAL
FROM VENDAS V
RIGHT JOIN PRODUTOS P
ON V.ID_PRODUTO = P.ID
WHERE V.ID_VENDA IS NULL



-- LEFT JOIN ou LEFT OUTER JOIN
SELECT 
	   V.ID_VENDA
	  ,V.ID_PRODUTO
	  ,P.ID
	  ,P.NOME
	  ,P.PRECO
	  ,V.QUANTIDADE
	  ,(P.PRECO * V.QUANTIDADE) AS TOTAL
FROM VENDAS V
LEFT JOIN PRODUTOS P
ON V.ID_PRODUTO = P.ID


-- LEFT JOIN EXCLUSIVO (SEM LINHAS EM COMUM)
SELECT 
	   V.ID_VENDA
	  ,V.ID_PRODUTO
	  ,P.ID
	  ,P.NOME
	  ,P.PRECO
	  ,V.QUANTIDADE
	  ,(P.PRECO * V.QUANTIDADE) AS TOTAL
FROM VENDAS V
LEFT JOIN PRODUTOS P
ON V.ID_PRODUTO = P.ID
WHERE P.ID IS NULL


-- JOIN com WHERE
SELECT 
	   V.ID_VENDA
	  ,V.ID_PRODUTO
	  ,P.ID
	  ,P.NOME
	  ,P.PRECO
	  ,V.QUANTIDADE
	  ,(P.PRECO * V.QUANTIDADE) AS TOTAL
FROM VENDAS V
 JOIN PRODUTOS P
ON V.ID_PRODUTO = P.ID


SELECT 
	   V.ID_VENDA
	  ,V.ID_PRODUTO
	  ,P.NOME
	  ,P.PRECO
	  ,V.QUANTIDADE
	  ,(P.PRECO * V.QUANTIDADE) AS TOTAL
FROM VENDAS AS V, PRODUTOS AS P
WHERE V.ID_PRODUTO = P.ID 


SELECT 
	   V.ID_VENDA
	  ,V.ID_PRODUTO
	  ,P.ID
	  ,P.NOME
	  ,P.PRECO
	  ,V.QUANTIDADE
	  ,(P.PRECO * V.QUANTIDADE) AS TOTAL
FROM VENDAS V
RIGHT JOIN PRODUTOS P
ON V.ID_PRODUTO = P.ID
WHERE V.ID_PRODUTO IS NULL


-- FULL OUTER JOIN
SELECT 
	   V.ID_VENDA
	  ,V.ID_PRODUTO
	  ,P.ID
	  ,P.NOME
	  ,P.PRECO
	  ,V.QUANTIDADE
	  ,(P.PRECO * V.QUANTIDADE) AS TOTAL
FROM VENDAS V
FULL JOIN PRODUTOS P
ON V.ID_PRODUTO = P.ID


-- FULL OUTER EXCLUSIVO (SEM LINHAS EM COMUM)
SELECT 
	   V.ID_VENDA
	  ,V.ID_PRODUTO
	  ,P.ID
	  ,P.NOME
	  ,P.PRECO
	  ,V.QUANTIDADE
	  ,(P.PRECO * V.QUANTIDADE) AS TOTAL
FROM VENDAS V
FULL OUTER JOIN PRODUTOS P
ON V.ID_PRODUTO = P.ID
WHERE P.ID IS NULL OR V.ID_VENDA IS NULL


-- CARDINALIDADE 1:1
SELECT COUNT(*) FROM [Person].[Person] -- 19972 LINHAS
SELECT COUNT(*) FROM [HumanResources].[Employee] -- 290 LINHAS
SELECT COUNT(*) FROM [Sales].[SalesPerson]   -- 17 LINHAS
 
 SELECT P.*
 FROM Person.Person AS P
 LEFT JOIN [HumanResources].[Employee] AS E
 ON P.BusinessEntityID = E.BusinessEntityID


-- JOIN COM 2 TABELAS
SET STATISTICS TIME ON;
GO

-- CONCEDENDO PERMISSAO PARA UM USARIO CRIAR DIAGRAMAS
ALTER AUTHORIZATION ON DATABASE::AdventureWorks TO "Bauer"
GO

SELECT 
	 e.LoginID
	,S.TerritoryID --Qual o nome do Territorio ?
	,S.SalesYTD
	,ST.Name AS NOME_TERRITORIO
FROM [HumanResources].[Employee] AS e
   INNER JOIN [Sales].[SalesPerson] AS S
ON e.BusinessEntityID = S.BusinessEntityID
INNER JOIN [Sales].[SalesTerritory] AS ST
ON S.TerritoryID = ST.TerritoryID





-- JOIN COM 3 TABELAS
SELECT 
	e.LoginID
	,s.TerritoryID 
	,s.SalesYTD
	,st.name AS 'NOME TERRITORIO'
FROM [HumanResources].[Employee] AS e
    INNER JOIN Sales.SalesPerson AS s
ON e.BusinessEntityID = s.BusinessEntityID
JOIN [Sales].[SalesTerritory] AS st
ON s.TerritoryID = st.TerritoryID


SELECT * FROM SALES.SALESTERRITORY WHERE TERRITORYID  = 3


--,t.Name AS TERRITORIO -- Nome do Territorio !!!
	--INNER JOIN Sales.SalesTerritory AS t
--ON S.TerritoryID = t.TerritoryID


-- JOIN ou WHERE em OUTER JOIN
----------- DATA POPULATION PORTION ----------------------------------------
 CREATE TABLE #MainTable
 (
 Productid INT IDENTITY(1,1),
 ProductName VARCHAR(50)
 )
 
 CREATE TABLE #ChildTable
 (
 Orderid INT IDENTITY(1,1),
 ProductId INT,
 OrderName VARCHAR(50)
 )
 
INSERT [#MainTable]
         (
         [ProductName]
         )
 SELECT 'FirstProduct'
  UNION ALL
 SELECT 'SecondProduct'
 UNION ALL
 SELECT 'ThirdProduct'
 

 INSERT [#ChildTable]
         (
         [ProductId]
         ,[OrderName]
        )
 SELECT 1, 'FirstOrder'
 UNION ALL
 SELECT NULL, 'SecondOrder'
 UNION ALL
 SELECT 2, 'ThirdOrder'

 SELECT * FROM [#MainTable]
 SELECT * FROM [#ChildTable]


------------------ EXAMPLE PORTION -----------------------------------------
 /* == SIMPLE EXAMPLE OF OUTER JOIN WITH NO FILTER CONDITION === */
 /* == THIS WILL GIVE ALL THE PRODUCTS AND THE ORDERS IF ANY === */
 SELECT * FROM [#MainTable] AS MT 
 LEFT OUTER JOIN [#ChildTable] AS CT 
 ON [MT].[Productid] = [CT].[ProductId]
 
 
 /* == EXAMPLE OF OUTER JOIN WITH A FILTER CONDITION    IN JOIN CLAUSE        === */
 /* == THIS WILL GIVE ALL THE PRODUCTS AND ONLY THE "FIRST ORDER"        === */
 SELECT * FROM [#MainTable] AS MT 
 LEFT OUTER JOIN [#ChildTable] AS CT 
 ON [MT].[Productid] = [CT].[ProductId]
 AND [OrderName] = 'FirstOrder'

 
 /* == EXAMPLE OF OUTER JOIN WITH A FILTER CONDITION    IN WHERE CLAUSE        === */
 /* == THIS WILL GIVE ONLY THOSE PRODUCTS WHICH HAVE THE FIRST ORDER     === */
 /* == THIS NOW HAS BECOME AN INNER JOIN                                    === */
 SELECT * FROM [#MainTable] AS MT 
 LEFT OUTER JOIN [#ChildTable] AS CT 
 ON [MT].[Productid] = [CT].[ProductId]
 WHERE [OrderName] = 'FirstOrder'


	

-- JOIN RETORNANDO APENAS 1 LINHA DO DETALHE
SELECT
  	 D.SalesOrderID
	,D.SalesOrderDetailID
	,D.UnitPrice 
	,D.LineTotal
	,H.*
FROM Sales.SalesOrderDetail D
JOIN Sales.SalesOrderHeader H
ON H.SalesOrderID = D.SalesOrderID
WHERE D.SalesOrderID =  43659
ORDER BY D.LineTotal DESC


-- MODO ELEGANTE E EFICIENTE
WITH TABELA (ID, DETAILID, UNITPRICE, TOTAL, PRICERANK) AS
(SELECT 
D.SALESORDERID, D.SalesOrderDetailID, D.UnitPrice, D.LineTotal
,row_number() OVER(PARTITION BY D.SalesOrderID
ORDER BY D.LineTotal DESC)
AS PriceRank
FROM Sales.SalesOrderDetail D)
SELECT * FROM TABELA
WHERE PRICERANK = 1

SELECT 
* 
FROM 
Purchasing.ProductVendor
ORDER BY ProductID

--SELF JOIN
SELECT DISTINCT pv1.ProductID, pv1.BusinessEntityID
FROM Purchasing.ProductVendor pv1
INNER JOIN Purchasing.ProductVendor pv2
ON pv1.ProductID = pv2.ProductID
AND pv1.BusinessEntityID <> pv2.BusinessEntityID
ORDER BY pv1.ProductID


-- Return all employees with ID of employee’s 
-- manager when a manager exists:
SELECT  
	 e.empid
	,e.lastname
	,e.title
	,e.mgrid
	,m.lastname
FROM [TSQL].[HR].[Employees] AS e
LEFT JOIN [TSQL].[HR].[Employees] AS m 
ON e.mgrid=m.empid;


-- Return all employees with ID of manager. 
-- This will return NULL for the CEO:
SELECT  
	 e.empid
	,e.lastname
	,e.title
	,m.mgrid
FROM [TSQL].[HR].[Employees] AS e
LEFT JOIN [TSQL].[HR].[Employees] AS m
ON e.mgrid=m.empid;


-- JOIN NO SQL 2000 (ANSI SQL-89)
SELECT COUNT(*) FROM Person.Person   --19972
SELECT COUNT(*) FROM HR.Employees -- 290

SELECT  P.BusinessEntityID, P.FirstName, E.JobTitle
FROM Person.Person as P
INNER JOIN HumanResources.Employee as E
ON P.BusinessEntityID = e.BusinessEntityID


SELECT P.BusinessEntityID, P.FirstName, E.JobTitle
FROM Person.Person as P, HumanResources.Employee as E
WHERE P.BusinessEntityID = e.BusinessEntityID


SELECT P.BusinessEntityID, P.FirstName, E.JobTitle
FROM Person.Person as P, HumanResources.Employee as E
WHERE P.BusinessEntityID *= e.BusinessEntityID


SELECT  P.BusinessEntityID, P.FirstName, E.JobTitle
FROM Person.Person as P
LEFT JOIN HumanResources.Employee as E
ON P.BusinessEntityID = e.BusinessEntityID



-- RIGHT JOIN OU LEFT JOIN ?
SELECT P.BusinessEntityID, P.FirstName, E.JobTitle
FROM Person.Person as P, HumanResources.Employee as E
WHERE E.BusinessEntityID *= P.BusinessEntityID




SELECT  P.BusinessEntityID, P.FirstName, E.JobTitle
FROM Person.Person as P
RIGHT JOIN HumanResources.Employee as E
ON P.BusinessEntityID = e.BusinessEntityID


-- CARDINALIDADE
-- Tabela doutor onde constará informações sobre o médico profissional;
-- Tabela paciente onde constará dados relativos aos assuntos médico e sobre o tratamento do paciente;
-- Tabela departamento onde será tratado as informações relativas as divisões departamentais do hospital.

-- 1:1 (1 para 1)
-- Já o relacionamento um-para-um (1:1) será usado nos casos onde o registro de uma tabela
-- só poderá ter uma associação com um registro de outra tabela. 
-- No nosso caso, isso caberia na relação entre um quarto de apartamento e um paciente. 
-- Pois um paciente só poderá estar em um determinado apartamento, e cada apartamento só 
-- poderá abrigar um determinado paciente (partindo do princípio de quartos individuais).


-- 1:N (1 para VÁRIOS)
-- Existirá o relacionamento um-para-vários (1:N) no relacionamento entre a tabela departamento 
-- em relação a tabela de médicos, pois um doutor, poderá trabalhar em somente um departamento do hospital, 
-- contudo, um departamento poderá ter vários doutores.


-- N:N (VÁRIOS para VÁRIOS)
-- Existirá o relacionamento vários-para-vários (N:N) entre os registros da tabela doutor e os registro da
-- tabela paciente, pois vários médicos poderão atender vários pacientes, um médico atende diversos paciente, 
-- assim como um paciente pode ser atendido por diversos médicos;


-- Lab. 4  - Página 176 ou 457  (PDF)
-- Exercícios (1,2,3,4 e 5) - 50 minutos
