---------------------------- CURIOSIDADES ----------------------------
USE Adventureworks
GO

-- 1 -- 

-- Consulta 1
SELECT
        *
    FROM
        HumanResources.Employee
    WHERE
        VacationHours = 0
        OR SickLeaveHours = 0;

-- Consulta 2
SELECT
        *
    FROM
        HumanResources.Employee
    WHERE
        0 IN ( VacationHours, SickLeaveHours )


-- Quais os resultados das consultas acima? Retornam a mesma coisa?

----------------------------------------------------------------------





-- 2 --

 DECLARE @testA TABLE ( i INT )
  DECLARE @test INT

  SELECT @test = ISNULL(i, -1)
      FROM @testA
  SELECT @test

  -- O que retorna da consulta acima ?






--The ISNULL (or COALESCE) function does not get executed until a row has been returned.  
--There are no rows in @testA
----------------------------------------------------------------------





-- 3 --
O que acontece quando se "pausa" o SQL Server database service? 

  a) Todas as consultas em execução são pausadas e uma mensagem é enviada a todas as conexões.  
  b) O servidor contina operando normalmente, porém nenhuma nova conexão será permitida.
  c) O servidor para todos os trabalhos excetos aqueles sendo executados por conexão administrativa dedicada (DAC).
  d) Todas as operações no SQL SERVER ficam proibidas exceto operações de backup e restore.  
 



----------------------------------------------------------------------



-- 4 --

-- Consulta 1
SET ROWCOUNT 2  -- desde SQL 2008
SELECT TOP 4 
  CustomerID
 FROM Sales.Customer AS c

 -- Consulta 2
SET ROWCOUNT 5
SELECT TOP 4 
  CustomerID
 FROM Sales.Customer AS c


-- Quantas linhas retornam das consultas 1 e 2 ?







-- SET ROWCOUNT overrides TOP if the value is smaller. If not, TOP controls the query results. 
----------------------------------------------------------------------




-- 5 --
USE tempdb
GO
CREATE TABLE TableTruncate (ID INT, name nvarchar(10))

INSERT INTO TableTruncate (ID, name)
SELECT 1, 'Jack'
UNION ALL
SELECT 2, 'Joe'
UNION ALL
SELECT 3,'Mak'
GO

SELECT * FROM TableTruncate

BEGIN TRAN

TRUNCATE TABLE TableTruncate
SELECT * FROM TableTruncate
ROLLBACK TRAN
SELECT * FROM TableTruncate    -- Linha X
DROP TABLE TableTruncate
GO

-- Quantas linhas retornam após a execução do select da "Linha X" ?








--There is no syntax error here. Data can be recovered at the point of the comment. If you use TRANSACTIONS in your code, TRUNCATE can be rolled back.  
----------------------------------------------------------------------



-- 6 --

-- Você está usando o SQL 2012 ou superior e criou um SYNONYM mas há um problema com ele.
-- Foi criado apontando para um objeto errado. Como corrigir o SYNONYM ? 

-- a) Alterando o synonym usando “ALTER SYNONYM” e apontar para o objeto correto.
-- b) Dropando o synonym e recriando com o apontamento correto.
-- c) Não há maneira de resolver uma vez criado o synonym.



----------------------------------------------------------------------


-- 7 --
SET IMPLICIT_TRANSACTIONS ON;

CREATE TABLE tempTable ( id INT)

INSERT INTO tempTable (id) VALUES (1), (2)

ROLLBACK

SELECT * FROM tempTable

SET IMPLICIT_TRANSACTIONS OFF

-- O que retorna da consulta acima?

-- a) Syntax error  
-- b) Retorna 1 linha com o valor (1)
-- c) Retorna 2 linhas com os valores (1, 2) 
-- d) Invalid object name 'tempTable’  






--In the implicit transaction mode, when you issue one or more DML or DDL statements, 
--or a SELECT statement, SQL Server starts a transaction, increments @@TRANCOUNT, 
--but does not automatically commit or roll back the statement. You must issue a
-- COMMIT or ROLLBACK interactively to finish the transaction. 
----------------------------------------------------------------------



-- 8 --
DECLARE @i int = 1;
IF 1 < 0
BEGIN;
    SET @i += 2;
    DECLARE @j int = @i * 2;
END;
SELECT @j;

-- O que retorna do código acima?

-- a) NULL 
-- b) 2
-- c) 6
-- d) O Select final dará erro



----------------------------------------------------------------------


-- 9 --
IF OBJECT_ID('tempdb..#t1') IS NOT NULL
    DROP TABLE #t1

CREATE TABLE #t1
    (
      ID INT IDENTITY(1, 1) ,
      Value NVARCHAR(10)
    )
GO

INSERT  INTO #t1
        SELECT  'A'
GO

SET IDENTITY_INSERT #t1 ON
INSERT  INTO #t1 (id, value) 
        SELECT  1 ,
                'A'

SET IDENTITY_INSERT #t1 OFF

SELECT * FROM #t1
-- Qual será o valor do ID da segunda linha?

-- a) 2
-- b) 1
-- c) Retorna erro de chave duplicada
-- d) Retorna um erro




--The Correct answer is an error is returned. An explicit value for the identity column in table '#t1' can only be specified when a column list is used and IDENTITY_INSERT is ON. 
-- 
----------------------------------------------------------------------


-- 10 --
DECLARE @Logic TABLE ( ID INT, Product VARCHAR(50) )

INSERT INTO @Logic
    VALUES  ( 1, 'Baseball Hat' ),
            ( 2, 'Bicycle' ),
            ( 3, 'Snowboard' ),
            ( 4, 'Goggles' ),
            ( 5, 'Shows' )

SELECT ID
    FROM @Logic
    WHERE Product = 'Bicycle' OR Product = 'Snowboard' AND ID = 4

-- Quais valores de ID são retornados nesta consulta?

-- a) 2
-- b) 2,3
-- c) 2,3,4
-- d) 1,2,3,4,5 
-- e) Nenhum ID



















-- The logic precedence in queries is NOT, AND, OR
----------------------------------------------------------------------