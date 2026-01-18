----- Module 14: Pivoting and Grouping Sets
USE AdventureWorks2016
GO

SELECT PurchaseOrderID, EmployeeID, VendorID
FROM Purchasing.PurchaseOrderHeader
ORDER BY EmployeeID, VendorID

-- PIVOT TABLES
-- Converte Valores em Colunas
SELECT PurchaseOrderID, EmployeeID, VendorID, OrderDate, SubTotal
FROM Purchasing.PurchaseOrderHeader
where  EmployeeID IN (250,251,256,257,258,260)
ORDER BY EmployeeID, VendorID


--WHERE VendorID = 1616 AND EmployeeID = 256

-- Somar por Subtotal
--SELECT 
VendorID, [250] AS '250', [251] AS '251', [256] AS '256', [257] AS '257', [260] AS '260', [258] AS '258'
FROM 
(SELECT SUBTOTAL,PurchaseOrderID, EmployeeID, VendorID
FROM Purchasing.PurchaseOrderHeader) AS p
PIVOT
(
SUM (SUBTOTAL) 
FOR EmployeeID IN
( [250], [251], [256], [257], [260], [258] )) AS PVT
ORDER BY VendorID





-- UNPIVOT TABLES
CREATE TABLE #PIVOTADA
(
	 Fornecedor int
	,[250] int
	,[251] int
	,[256] int
	,[257] int
	,[260] int
	,[258] int
)

INSERT INTO #PIVOTADA
SELECT 
VendorID, [250] AS '250', [251] AS '251', [256] AS '256', [257] AS '257', [260] AS '260', [258] AS '258'
FROM 
(SELECT PurchaseOrderID, EmployeeID, VendorID
FROM Purchasing.PurchaseOrderHeader) AS p
PIVOT
(
COUNT (PurchaseOrderID) 
FOR EmployeeID IN
( [250], [251], [256], [257], [260], [258] )) AS PVT


SELECT * FROM #PIVOTADA where Fornecedor=1500



SELECT EmployeeID, Fornecedor, PurchaseOrderID AS Qtde
FROM #PIVOTADA
UNPIVOT (PurchaseOrderID FOR EmployeeID
IN ([250], [251], [256], [257], [260], [258])) UPVT
ORDER BY EmployeeID


SELECT PurchaseOrderID, EmployeeID, VendorID
FROM Purchasing.PurchaseOrderHeader
WHERE EmployeeID = 250 and VendorID = 1500


-- GROUPINGSETS
-- Elimina multiplas consultas GROUP BY unidas
-- Uma cláusula GROUP BY que use GROUPING SETS pode gerar um conjunto 
-- de resultados equivalente ao gerado por um UNION ALL de múltiplas cláusulas 
-- simples GROUP BY. GROUPING SETS pode gerar um resultado equivalente ao gerado 
-- por uma operação simples GROUP BY, ROLLUP ou CUBE. Combinações diferentes 
-- de GROUPING SETS, ROLLUP ou CUBO podem gerar conjuntos de resultados equivalentes.

SELECT BusinessEntityID, NULL as TerritoryID, NULL AS Bonus, SUM(salesYTD) AS [TOTAL_VENDAS]
FROM Sales.SalesPerson 
GROUP BY BusinessEntityID

UNION ALL

SELECT NULL as BusinessEntityID, TerritoryID, NULL AS Bonus, SUM(salesYTD) AS [TOTAL_VENDAS]
FROM Sales.SalesPerson 
GROUP BY TerritoryID


UNION ALL

SELECT NULL AS BusinessEntityID, NULL AS TerritoryID, Bonus, SUM(salesYTD) AS [TOTAL_VENDAS]
FROM Sales.SalesPerson 
GROUP BY Bonus



SELECT BusinessEntityID, TerritoryID, Bonus, SUM(salesYTD) AS [TOTAL_VENDAS]
FROM Sales.SalesPerson 
GROUP BY GROUPING SETS (Bonus,TerritoryID,BusinessEntityID)



SELECT T.[Group] AS 'Region', T.CountryRegionCode AS 'Country'
    ,S.Name AS 'Store', H.SalesPersonID
    ,SUM(TotalDue) AS 'Total Sales'
FROM Sales.Customer AS C
    INNER JOIN Sales.Store AS S
        ON C.StoreID  = S.BusinessEntityID 
    INNER JOIN Sales.SalesTerritory AS T
        ON C.TerritoryID  = T.TerritoryID 
    INNER JOIN Sales.SalesOrderHeader AS H
        ON C.CustomerID = H.CustomerID
WHERE T.[Group] = 'Europe'
    AND T.CountryRegionCode IN('DE', 'FR')
   -- AND SUBSTRING(S.Name,1,4)IN('Vers', 'Spa ')
GROUP BY GROUPING SETS
    (T.[Group], T.CountryRegionCode, S.Name, H.SalesPersonID)
ORDER BY T.[Group], T.CountryRegionCode, S.Name, H.SalesPersonID;



-- CUBE e ROLLUP
-- Gera informação de sumário na consulta
SELECT ProductID
,Shelf
,Bin
,Quantity
FROM Production.ProductInventory


-- GROUP BY
SELECT 
ProductID as PRODUTO
,Shelf as PRATELEIRA
,SUM(Quantity) AS quantidade
FROM Production.ProductInventory
WHERE ProductID<6
GROUP BY ProductID,Shelf with cube

--WITH ROLLUP
--GROUP BY ROLLUP(ProductID,Shelf)


-- CUBES
-- Gera um resultado que mostra as agregações de todos os valores combinados das colunas mencionadas
SELECT 
ProductID as PRODUTO,
Shelf as PRATELEIRA,
SUM(Quantity) AS quantidade
FROM Production.ProductInventory
WHERE ProductID<6
GROUP BY CUBE(ProductID,Shelf) -- OU -- GROUP BY ProductID, Shelf WITH CUBE


-- ROLLUP
-- Gera um resultado que mostra as agregações para uma hierarquia de valores das colunas selecionadas
SELECT 
ProductID as PRODUTO,
Shelf as PRATELEIRA,
SUM(Quantity) AS QUANTIDADE
FROM Production.ProductInventory
WHERE ProductID<6
GROUP BY ROLLUP(ProductID,Shelf) -- OU -- GROUP BY ProductID, Shelf WITH ROLLUP



-- GROUPING e GROUPING_ID

-- Usado para distinguir valores nulos que foram retornados pelos comandos: ROLLUP, CUBE ou GROUPING SETS
SELECT 
ProductID as PRODUTO
,Shelf as PRATELEIRA
,SUM(Quantity) AS quantidade
FROM Production.ProductInventory
WHERE ProductID < 6
GROUP BY ProductID, Shelf WITH CUBE



-- COM ISNULL SIMPLES
SELECT 
ISNULL(Shelf,'TUDO') AS 'PRATELEIRA',
ISNULL(Convert(varchar(20), ProductID),'TODOS OS PRODUTOS') as PRODUTO,
SUM(Quantity) AS quantidade
FROM Production.ProductInventory
WHERE ProductID < 6
GROUP BY ProductID, Shelf WITH CUBE



-- COM COALESCE
SELECT 
COALESCE(CAST(ProductID AS VARCHAR(20)),'TODOS OS PRODUTOS') as PRODUTO
,COALESCE(Shelf,'TOTAL DO PRODUTO:' + CAST(ProductID AS VARCHAR(20)) ,CAST(ProductID AS VARCHAR(20)),'TODAS AS PRATELEIRAS')  as PRATELEIRA
,SUM(Quantity) AS quantidade
FROM Production.ProductInventory
WHERE ProductID < 6
GROUP BY ProductID, Shelf WITH CUBE




SELECT 
ProductID as PRODUTO
,Shelf as PRATELEIRA
,SUM(Quantity) AS quantidade
,GROUPING_ID(ProductID) AS GrupoP
,GROUPING_ID(Shelf) AS GrupoS
,GROUPING_ID(ProductID,Shelf) AS GrupoComposto
FROM Production.ProductInventory
WHERE ProductID < 6 
GROUP BY ProductID, Shelf WITH CUBE







-- Função que calcula o nível de agrupamento.  
-- GROUPING_ID pode ser usada apenas na lista SELECT <select>, na cláusula HAVING ou ORDER BY, quando GROUP BY for especificada. \
-- GROUPING_ID considera valor binario da combinacao dos campos, exemplo:
-- ( ProductID = 0, Shelf = 1 )  = 1 (AGRUPADO POR PRATELEIRA: TODOS OS PRODUTOS)
-- ( ProductID = 1, Shelf = 0 )  = 2 (AGRUPADO POR PRODUTO: TODAS AS PRATELEIRAS)
-- ( ProductID = 1, Shelf = 1 )  = 3 (AGRUPADO POR AMBOS: PRODUTO, PRATELEIRA)


SELECT 
 	ISNULL(Convert(varchar(20), ProductID),'TODOS OS PRODUTOS') as PRODUTO
	,CASE
    WHEN GROUPING_ID(ProductID, Shelf) = 0 THEN Shelf						-- LINHA DO DETALHE
    WHEN GROUPING_ID(ProductID, Shelf) = 1 THEN N'TOTAL DO PRODUTO ' + CASt(ProductID AS VARCHAR(10))		-- AGRUPAMENTO PELO PRIMEIRO CAMPO
	WHEN GROUPING_ID(ProductID, Shelf) = 2 THEN N'PRATELEIRA: ' + Shelf		-- AGRUPAMENTO PELO SEGUNDO CAMPO
    WHEN GROUPING_ID(ProductID, Shelf) = 3 THEN N'TOTAL GERAL'				-- AGRUPAMENTO POR AMBOS OS CAMPOS
    END AS N'PRATELEIRA'
	,SUM(Quantity) AS quantidade
FROM Production.ProductInventory
WHERE ProductID < 6
GROUP BY ProductID, Shelf WITH CUBE




-- Lab. 14 - Pg.144_Part2 ou Pg.425_Part2
-- Página 492 ou 773 (PDF)
-- Exercícios 1,2 e 3 - 60 minutos