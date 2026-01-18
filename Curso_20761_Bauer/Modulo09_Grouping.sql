----- Modulo 9: Grouping and Aggregating Data
USE [Adventureworks];
GO


SELECT 
	 ProductID
	,Quantity
	,Shelf -- prateleira
	,Bin   -- divisoria
FROM 
	Production.ProductInventory --ESTOQUE
WHERE 
	ProductID IN (1)
ORDER BY ProductID, Shelf ASC



-- SUM, MIN, MAX
SELECT
SUM(Quantity) AS TOTAL  
	,MIN(quantity) AS MINIMO 
	,MAX(Quantity) AS MAXIMO 
FROM 
    Production.ProductInventory
GROUP BY PRODUCTID



WHERE 
	ProductID = 1

SET STATISTICS IO ON

SELECT
  COLOR AS COR
  ,COUNT(*) AS QTDE
FROM PRODUCTION.Product
WHERE COLOR IS NOT NULL
GROUP BY COLOR

SELECT
  COLOR AS COR
  ,COUNT(*) AS QTDE
FROM PRODUCTION.Product
GROUP BY COLOR
HAVING COLOR IS NOT NULL
--Blue  26
--Black 93







SELECT
  COLOR AS COR
  ,COUNT(*) AS QTDE
FROM PRODUCTION.Product --504 ROWS TOTAL
WHERE COLOR IS NOT NULL
GROUP BY COLOR
HAVING COUNT(*) > 20



--WHERE COLOR = 'BLUE' --26 BLUE

-- REQUISICAO

COR    QTDE
BLUE    26
BLACK   X
YELLOW  Y
RED     Z









cor   qtde
blue  26
black x
yellow y
red     z




SELECT 
	
	COUNT(*) AS 'QTDE.'
	,MIN(StandardCost) AS MINIMO
	,MAX(StandardCost) AS MAXIMO
	,AVG(StandardCost) AS MEDIA
FROM PRODUCTION.Product --504 ROWS TOTAL
--WHERE COLOR NULL






GROUP BY COLOR




COLOR    QTDE.
BLACK     10
BLUE      26
YELLOW    X
GRAY      Y












SELECT COLOR, COUNT(*) AS QTD
FROM PRODUCTION.Product
WHERE COLOR IS NOT NULL
GROUP BY COLOR


SELECT COLOR, COUNT(*) AS QTD
FROM PRODUCTION.Product
GROUP BY COLOR
HAVING COLOR IS NOT NULL


SELECT COLOR, COUNT(*) AS QTD
FROM PRODUCTION.Product
GROUP BY COLOR
HAVING COUNT(*) > 40 AND COLOR IS NOT NULL









--WHERE COLOR IS NOT NULL
GROUP BY COLOR
HAVING COUNT(*)>30  OR COLOR = 'GREY' 

--AND COLOR IS NOT NULL


SELECT COLOR, COUNT(*) AS QTDE
FROM PRODUCTION.Product
WHERE COLOR IS NOT NULL
GROUP BY COLOR






SELECT COLOR
FROM 
	 PRODUCTION.Product
ORDER BY COLOR  DESC


-- GROUP BY
SELECT  
	  COLOR AS COR
	 ,COUNT(*) AS QUANTIDADE
FROM 
	 PRODUCTION.Product
WHERE COLOR IS NOT NULL
GROUP BY COLOR
HAVING COUNT(*) > 50  OR COLOR in ('Blue','Yellow')








SELECT * FROM PRODUCTION.Product 
WHERE COLOR = 'BLACK'


GROUP BY COLOR


HAVING  COUNT(*) > 20



SELECT 
     Color
FROM 
	 PRODUCTION.PRODUCT
WHERE Color IS NOT NULL


SELECT 
	COUNT(*) RED_QTDY
FROM 
	PRODUCTION.Product
WHERE 
	Color = 'Red'


SELECT 
* 
FROM 
	PRODUCTION.Product
WHERE 
	Color = 'White'



SELECT  
	 COLOR
	,COUNT(*) AS QUANTIDADE
FROM PRODUCTION.Product
WHERE COLOR IS NOT NULL
GROUP BY COLOR
HAVING COUNT(*) > 10


-- REFERENCIA
SELECT * FROM Production.ProductInventory
WHERE ProductID < 6


-- GROUP BY e GROUP BY ALL 
SELECT 
ProductID AS PRODUTO
,Shelf AS PRATELEIRA
,SUM(Quantity) AS quantidade
FROM Production.ProductInventory
WHERE ProductID < 6 
GROUP BY ProductID,Shelf 


--WITH ROLLUP
-- WITH CUBE

--WITH ROLLUP
--GROUP BY ROLLUP (ProductID,Shelf)







--order by   ProductID,Shelf

-- ROLLUP
SELECT 
ProductID as PRODUTO,
Shelf as PRATELEIRA,
SUM(Quantity) AS quantidade
FROM Production.ProductInventory
WHERE ProductID < 6 
GROUP BY ROLLUP (ProductID,Shelf)
--GROUP BY ProductID,Shelf WITH ROLLUP





-- CUBE
SELECT 
ProductID as PRODUTO,
Shelf as PRATELEIRA,
SUM(Quantity) AS quantidade
FROM Production.ProductInventory
WHERE ProductID < 6 
GROUP BY ProductID,Shelf --WITH CUBE

--HAVING SUM(Quantity) < 400


-- RETORNA TODAS AS LINHAS DA TABELA PRINCIPAL
SELECT 
ProductID as PRODUTO,
Shelf as PRATELEIRA,
SUM(Quantity) AS quantidade
FROM Production.ProductInventory
WHERE ProductID < 6 
GROUP BY ALL ProductID,Shelf 



-- HAVING ProductInventory
SELECT 
ProductID as PRODUTO,
Shelf as PRATELEIRA,
SUM(Quantity) AS QUANTIDADE
FROM Production.ProductInventory
WHERE ProductID<6
GROUP BY ProductID,Shelf
HAVING SUM(Quantity) > 800

SELECT * 
FROM Production.ProductInventory

-- HAVING SalesOrderHeader
SELECT
YEAR(OrderDate) as Ano
,salespersonid
,COUNT(subtotal) as NumeroVendas
,SUM(subtotal) as totalgeral
,AVG(subtotal) as media
,MIN(subtotal) as menorVenda
,MAX(subtotal) as maiorVenda
FROM Sales.SalesOrderHeader
GROUP BY SalesPersonID, YEAR(OrderDate)
--HAVING sum(subtotal) > 800000 AND salespersonid IS NOT NULL
ORDER BY SalesPersonID, YEAR(OrderDate)


SELECT COUNT(COLOR)
FROM Production.Product
-- 504 ROWS


DROP TABLE MEDIA


CREATE TABLE MEDIA
(ID INT
,VALOR DECIMAL(4,2)
)

INSERT MEDIA VALUES (1,2.0),(2,4.0),(3,NULL)
SELECT * FROM MEDIA

INSERT MEDIA VALUES (4,0.0)


SELECT * FROM MEDIA


SELECT 
	MIN(ISNULL(VALOR,0)) AS MINIMO
	,MAX(VALOR) AS MAXIMO
	,COUNT(ISNULL(VALOR,0)) AS CONTADOR
	,SUM(VALOR) AS TOTAL
	,AVG(VALOR) AS MEDIA
	,AVG(ISNULL(VALOR,0)) AS MEDIA_0
FROM MEDIA


--GRANULARIDADE
--Granularidade diz respeito ao nível de detalhe ou de resumo contido 
--nas unidades de dados existentes no banco de dados. Quanto maior o 
--nível de detalhes, menor o nível de granularidade. O nível de granularidade 
--afeta diretamente o volume de dados armazenado no data warehouse e ao mesmo 
--tempo o tipo de consulta que pode ser respondida.

--Quando se tem um nível de granularidade muito alto o espaço em disco e o
--número de índices necessários se tornam bem menores, porém há uma correspondente 
--diminuição da possibilidade de utilização dos dados para atender a consultas 
--detalhadas 


-- Lab. 9 - Página 330 ou 725 (PDF)
-- Exercícios (1,2,3 e 4) - 80 minutos