----- Modulo 16: Programming with T-SQL

USE Adventureworks
GO


-- GO (BATCHES)
DECLARE @QUANTIDADE INT = 30
--GO
SELECT @QUANTIDADE



SET @QUANTIDADE = 30


--GO -- USO EQUIVOCADO



--DROP TABLE TESTE
--DROP VIEW VTESTE

IF OBJECT_ID('TESTE','U') IS NOT NULL
	DROP TABLE TESTE;

IF OBJECT_ID('VTESTE','V') IS NOT NULL
	DROP VIEW VTESTE;


CREATE TABLE TESTE (ID INT, NOME VARCHAR(100))
go
CREATE VIEW VTESTE AS (SELECT * FROM TESTE)



SELECT * FROM TESTE
SELECT * FROM VTESTE

--DROP TABLE t1

IF OBJECT_ID('dbo.t1','U') IS NOT NULL
	DROP TABLE dbo.t1;

CREATE TABLE dbo.t1 (c1 INT PRIMARY KEY, c2 INT, c3 NCHAR(5));
GO

-- Batch Valido
SET NOCOUNT ON

INSERT INTO dbo.t1 VALUES(1,2,N'abc');
INSERT dbo.t1 VALUES(6,3,N'def');
GO

SELECT * FROM T1

INSERT dbo.t1 VALUES(3,2,N'abc');
GO
INSERT dbo.t1 VALUES(4,3,N'def');

SET NOCOUNT OFF


SELECT c1, c2, c3 FROM dbo.t1;
GO

TRUNCATE TABLE dbo.t1;
GO

-- Batch Invalido (chave primaria duplicada)
SET NOCOUNT ON

INSERT INTO dbo.t1 VALUES(2,2,N'abc');
INSERT INTO dbo.t1 VALUES(2,3,N'def');

SELECT * FROM T1

-- Batch Invalido (tabela inexistente)
INSERT INTO dbo.t1 VALUES(333,3,N'def');
INSERT INTO dbo.t11 VALUES(222,2,N'abc');
GO



-- Batch Invalido (Comando errado)
INSERT INTO dbo.t1 VALUES(9,3,N'def');
go
INSERT INTO dbo.t1 VALUE(10,2,N'abc');






-- Resultado
SELECT c1, c2, c3 FROM dbo.t1;


-- Synonyms
-- Pode apontar para tabelas, views, procedures e functions

USE TSQL
GO

IF OBJECT_ID('Production.ProdsByCategory','P') IS NOT NULL
	DROP PROC Production.ProdsByCategory;
GO

CREATE PROC Production.ProdsByCategory
(@numrows AS int, @catid AS int)
 AS
SELECT TOP(@numrows) productid, productname, unitprice
FROM Production.Products
WHERE categoryid = @catid;
GO

-- Teste 
EXEC TSQL.Production.ProdsByCategory @catid = 1,@numrows = 12


-- Mudando de base
USE [20461]
GO

SELECT * FROM TSQL.PRODUCTION.PRODUCTS

EXEC TSQL.Production.ProdsByCategory @catid = 1,@numrows = 3

DROP SYNONYM Produtos

CREATE SYNONYM Produtos_Categoria
FOR TSQL.Production.ProdsByCategory;


exec Produtos_Categoria 10, 2



SELECT * FROM [Produtos]



SELECT * FROM Production.Product

EXEC Adventureworks.[dbo].[usp_sel_empregados]

EXEC Adventureworks.Production.ProdsByCategory 5,3


DROP SYNONYM PorCategoria

CREATE SYNONYM PorCategoria
FOR Adventureworks.[dbo].[usp_sel_empregados]

EXEC Production.ProdsByCategory 5,3


EXEC PorCategoria 'M'




-- Listando Synonyms existentes
SELECT *
FROM sys.synonyms;
GO


-- Limpeza
USE Adventureworks
GO

IF OBJECT_ID('Production.ProdsByCategory','P') IS NOT NULL
	DROP PROC Production.ProdsByCategory;
GO


USE tempdb;
GO

IF OBJECT_ID('ProdutosPorCategoria','P') IS NOT NULL
	DROP PROC PProdutosPorCategoria;
GO

USE TSQL
GO



--IF..ELSE
IF OBJECT_ID('Production.ProdsByCategory','P') IS NULL
  BEGIN	
   	PRINT 'O objeto nao existe';
	PRINT 'CRIAR A PROCEDURE';
   END
ELSE
   BEGIN
    PRINT 'EXISTE: ELIMINANDO A PROCEDURE';
    DROP PROC Production.ProdsByCategory;
   END
GO



IF OBJECT_ID('HR.Employees') IS NOT NULL
BEGIN
	PRINT 'O objeto jah existe';
END;

USE Adventureworks
GO


IF OBJECT_ID('HR.Employees') IS NULL
BEGIN
	PRINT 'O objeto nao existe';
END
ELSE
BEGIN
	PRINT 'O objeto Existe asdasd';
END;

USE TSQL
GO

-- IF EXIST
IF EXISTS (SELECT 1 FROM Sales.EmpOrders WHERE empid =1)
	BEGIN
		PRINT 'Este empregado possui pedidos associados';
	END
	ELSE
		PRINT 'Este empregado NAO possui pedidos associados';
GO


-- WHILE
DROP TABLE FONES
CREATE TABLE FONES (ID INT, NOME VARCHAR(100))

--TRUNCATE TABLE FONES


--select count(*) from fones

DECLARE @empid AS INT = 1
WHILE @empid <=20000
	BEGIN

		INSERT INTO FONES (id,nome) 
		VALUES (@empid,CONCAT('NOME_', @empid))

		SET @empid += 1;
	END;

		--VALUES (@empid,'NOME_' + CONVERT(VARCHAR(10), @empid))
		--PRINT CONVERT(VARCHAR(10), @empid)
	TRUNCATE TABLE FONES
	
	SELECT COUNT(*) FROM FONES
	
	SELECT * FROM FONES



	-- INSERIR MIL LINHAS REPETIDAS COM COMANDO GO
	-- PARA POUCAS REPETICOES (<1000)
`



-- WHILE e BREAK
DECLARE @a AS INT, @b AS INT;
SET @a = 1
SET @b = 150000

WHILE @a <= @b
	BEGIN
		PRINT convert(varchar(10), @a)
		
		--IF @a = 100000  BREAK --RETURN ;

		SET @a += 1

		--WAITFOR DELAY '00:00:05'
	END;


-- Lab. 16 - Página 583 ou 799
-- -- Exercícios 1,2,3 e 4 - 60 minutos


