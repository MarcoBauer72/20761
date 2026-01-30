----- Stored Procedure Parameter Sniffing -----

--- Brent
USE AdventureWorks2012
GO

-- As 3 consultas abaixo retornam 2 linhas, 257 lihas e 4.688 linhas respectivamente.
-- Dois planos de execucao foram criados embora a query praticamente a mesma!
SELECT SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE ProductID = 897;  -- 2 linhas
 
SELECT SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE ProductID = 945; -- 257 linhas

SELECT SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE ProductID = 870; -- 4.688 linhas

-- O optimizer decidiu no ultimo caso rodar um "index scan" ao invés de um "index seek" por
-- se tratar de muitas linhas a serem retornadas


-- Criando uma Stored Procedure Parametrizada
CREATE PROCEDURE Get_OrderID_OrderQty
@ProductID INT
AS
SELECT SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE ProductID = @ProductID;


-- SET STATISTCS IO ON

-- Executando a PROC para 4.688 linhas
EXEC Get_OrderID_OrderQty @ProductID=870 -- Foi gerado um plano com "index scan"


-- Executando a PROC para 2 linhas
EXEC Get_OrderID_OrderQty @ProductID=897 -- Foi gerado o mesmo plano acima com "index scan"

-- O estimated number rows e actual number of rows estao bem diferentes!!!!
-- Ao selecionar "Show Execution Plan XML", na tag "ParameterCompiledValue", pode-se
-- notar que ele compilou com o valor 870!!!


DBCC FREEPROCCACHE
GO

EXEC Get_OrderID_OrderQty @ProductID=897;

EXEC Get_OrderID_OrderQty @ProductID=870



-- Recompiling ALL
ALTER PROCEDURE Get_OrderID_OrderQty
@ProductID INT
WITH RECOMPILE
AS
SELECT SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE ProductID = @ProductID;


-- Recompiling OPTION
ALTER PROCEDURE Get_OrderID_OrderQty
@ProductID INT
AS
SELECT SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE ProductID = @ProductID
OPTION (RECOMPILE)


EXEC Get_OrderID_OrderQty @ProductID=870


EXEC Get_OrderID_OrderQty @ProductID=897


-- OPTION (OPTIMIZE FOR UNKOWN) - como declarar uma variavel local. Bom para tabelas onde os dados estao distruibos igualmente

-- OPTION (OPTIMIZE FOR @ProductID=870) - para o maior retorno de linhas



---  https://www.brentozar.com/archive/2013/06/the-elephant-and-the-mouse-or-parameter-sniffing-in-sql-server/