----- Modulo 19: Improving Query Performance
USE Adventureworks
GO

------------------------------- SET STATISTICS TIME ----------------------------

-- Exibe o número de milissegundos necessários para analisar, 
-- compilar e executar cada instrução. 

--SET STATISTICS TIME ON;
--GO

--------------------------------------------------------------------------------


-------------------------------- SET STATISTICS IO -----------------------------

-- Faz o SQL Server exibir informações referentes à quantidade de atividade
-- em disco gerada pelas instruções Transact-SQL.

--SET STATISTICS IO ON;
--GO

--------------------------------------------------------------------------------


-------------------------------- SET SHOWPLAN_TEXT -----------------------------

-- Faz com que o Microsoft SQL Server não execute as instruções Transact-SQL.  
-- Em lugar disso, o SQL Server retorna informações detalhadas sobre como 
-- as instruções são executadas. 

-- SET SHOWPLAN_TEXT ON;
-- GO

--------------------------------------------------------------------------------


-------------------------------- SET SHOWPLAN_XML -------------------------------

-- Faz com que o SQL Server não execute instruções Transact-SQL.  
-- Em vez disso, o SQL Server retorna informações detalhadas sobre como
-- as instruções serão executadas no formulário de um documento XML bem definido. 

-- SET SHOWPLAN_XML ON;
-- GO

--------------------------------------------------------------------------------
SET STATISTICS IO ON;
GO

SELECT 
 [BusinessEntityID]
,[FirstName] 
FROM Person.Person
WHERE BusinessEntityID
NOT IN
	( SELECT DISTINCT(BusinessEntityID) FROM [HumanResources].[Employee] )



SELECT
PES.[BusinessEntityID]
,[FirstName]
 FROM Person.Person AS PES
LEFT JOIN [HumanResources].[Employee]  AS EMP
ON PES.BusinessEntityID = EMP.BusinessEntityID
WHERE EMP.BusinessEntityID IS NULL

SET STATISTICS IO OFF;
GO



--SET STATISTICS IO OFF;
--GO


SET STATISTICS TIME OFF;
GO

IF OBJECT_ID('SEMINDICE') IS NOT NULL
DROP TABLE SEMINDICE 

IF OBJECT_ID('COMINDICE') IS NOT NULL
DROP TABLE COMINDICE 



CREATE TABLE SEMINDICE -- TABELA HEAP = SEM INDICE
(
	ID   INT IDENTITY
	,NOME VARCHAR(100)
)

CREATE TABLE COMINDICE -- TABELA HEAP = SEM INDICE
(
	ID   INT IDENTITY
	,NOME VARCHAR(100)
)

INSERT INTO SEMINDICE
SELECT FirstName
FROM PERSON.Person

INSERT INTO COMINDICE
SELECT FirstName
FROM PERSON.Person


SET STATISTICS IO ON;
GO

SELECT * from SEMINDICE
WHERE ID = 10

SELECT * from COMINDICE
WHERE ID = 10

SET STATISTICS IO OFF;
GO

SP_SPACEUSED 'COMINDICE'



CREATE TABLE COMINDICE
(
	ID   INT IDENTITY
	,NOME VARCHAR(100)
)

INSERT INTO COMINDICE
SELECT FirstName
FROM PERSON.Person


CREATE CLUSTERED INDEX IX_ID
    ON COMINDICE (ID)
	
	
SET STATISTICS IO ON;
GO

SELECT * from SEMINDICE
WHERE ID = 10


SELECT * from COMINDICE
WHERE ID = 10

SET STATISTICS IO OFF;
GO


SP_SPACEUSED SEMINDICE

SET STATISTICS IO ON;
GO

SELECT * from SEMINDICE
WHERE NOME LIKE 'A%'


SELECT * from COMINDICE 
WHERE NOME LIKE 'A%' 


SET STATISTICS IO OFF;
GO

SP_SPACEUSED COMINDICE

CREATE NONCLUSTERED INDEX IX_NOME
    ON COMINDICE (NOME)
	


-- SET STATISTICS TIME ON;
SET STATISTICS TIME ON;
GO
SET STATISTICS TIME OFF;
GO 

SET STATISTICS TIME ON;
GO

SET STATISTICS TIME ON;
GO

SELECT Name
FROM Production.Product AS P
WHERE EXISTS
    (
	 SELECT 1 FROM Production.ProductSubcategory AS PS
     WHERE PS.Name = 'Wheels'
    -- AND PS.ProductSubcategoryID = P.ProductSubcategoryID
	)


-- NOT EXISTS	
SELECT Name
FROM Production.Product AS P
WHERE NOT EXISTS
    (
	 SELECT 1 FROM Production.ProductSubcategory AS PS
     WHERE PS.Name = 'Wheals'
    -- AND PS.ProductSubcategoryID = P.ProductSubcategoryID
	)



SET STATISTICS TIME OFF;
GO 



SET STATISTICS TIME ON;
GO

SELECT P.Name
FROM Production.Product AS P
JOIN Production.ProductSubcategory AS PS
ON P.ProductSubcategoryID = PS.ProductSubcategoryID
WHERE PS.Name = 'Socks'




SET STATISTICS TIME OFF;
GO








SET STATISTICS TIME ON;
GO


SELECT Name
FROM Production.Product AS P
WHERE EXISTS
    (
	 SELECT * FROM Production.ProductSubcategory AS PS
     WHERE PS.Name = 'Socks'
     AND PS.ProductSubcategoryID = P.ProductSubcategoryID
	)


SELECT Name
FROM Production.Product AS P
WHERE NOT EXISTS
    (
	 SELECT * FROM Production.ProductSubcategory AS PS
     WHERE PS.Name = 'Socks'
     AND PS.ProductSubcategoryID = P.ProductSubcategoryID
	)

SET STATISTICS TIME OFF;
GO



----- Optimize For Ad Hoc Workloads ----- 
-- Essa opção aumenta a eficiência do Plan Cache em relação a consultas Ad-Hoc.

-- Foi implementada a partir do SQL Server 2008 e permite se habilitado, quando o SQL Server precisar 
-- compilar um batch pela primeira vez, em vez de salvar um Plano de Execução Completo (Full Compiled Plan) 
-- como é realizado por padrão o mesmo ira armazenar do que chamamos de Stub Compiled Plan. 
-- Sendo assim o armazenamento desse plano é muito menos custoso para a Engine do banco de dados ocupando 
-- aproximadamente 18 Byte.

-- Cada Batch (T-SQL, Procedure, View…) quando executado cria um plano de execução no qual é armazenado dentro 
-- do banco de dados para caso utilizado novamente seja reusado. Por padrão quando passamos uma consulta para
-- o banco de dados é necessário que o SQL Server busque essas informações e assim armazene um plano de execução. 
-- Porém, muitas consultas que são realizadas dentro do banco de dados são consultas nas quais provavelmente não 
-- serão executadas novamente, fazendo com que a mesma ocupe espaço e recurso da máquina, essas consultas 
-- são chamadas de Ad-Hoc.


-- Limpando o Cache 
DBCC FREEPROCCACHE

DBCC DROPCLEANBUFFERS


sp_configure 'show advanced options',1
RECONFIGURE
GO

sp_configure 'optimize for ad hoc workloads',1
RECONFIGURE
 

USE Adventureworks
GO

SELECT * FROM Production.ProductSubcategory AS PS
WHERE PS.Name = 'Socks'


SELECT usecounts, cacheobjtype, objtype, TEXT
FROM sys.dm_exec_cached_plans
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
WHERE usecounts > 0 AND
TEXT LIKE 'SELECT * FROM Production.ProductSubcategory%'
ORDER BY usecounts DESC;
GO


sp_configure 'show advanced options',1
RECONFIGURE
GO

sp_configure 'optimize for ad hoc workloads',1
RECONFIGURE


-- Referência:
-- http://luanmorenodba.wordpress.com/2012/05/24/optimize-for-ad-hoc-workloads/


---------------------------------- SET FORCEPLAN  ------------------------------

-- Quando FORCEPLAN está definido como ON, o otimizador de consulta do SQL Server 
-- processa uma ligação na mesma ordem conforme as tabelas são exibidas na 
-- cláusula FROM de uma consulta.  Além disso, configurar FORCEPLAN como ON força 
-- o uso de uma junção de loop aninhado, a não ser que outros tipos de junção 
-- sejam necessários ao construir um plano para a consulta ou eles sejam solicitados
-- com dicas de junção ou dicas de consulta. 
-- SET FORCEPLAN basicamente substitui a lógica usada pelo otimizador de consulta 
-- para processar uma instrução SELECT Transact-SQL.  Os dados retornados pela 
-- instrução SELECT são os mesmos independentemente dessa configuração. 
-- A única diferença é o modo pelo qual o SQL Server processa as tabelas para 
-- satisfazer a consulta. 

-- Também podem ser usadas dicas do otimizador de consulta em consultas para 
-- afetar a forma como o SQL Server processa a instrução SELECT.  

-- SET FORCEPLAN é aplicado na execução ou em tempo de execução e não no 
-- momento da análise. 


--SET FORCEPLAN ON;
--GO

--------------------------------------------------------------------------------


-- SQL HINTS:
-- http://technet.microsoft.com/pt-br/library/ms181714(v=sql.110).aspx


-- Exibe a última instrução enviada de um cliente a uma instância do MicrosoftSQL Server
-- DBCC INPUTBUFFER (SESSIONID)


-- Lab. 19 - Página 658 ou 823 (PDF único)
-- Página 310 (Part2.pdf) ou Página 475 (Part2.pdf)
-- Exercícios 1 e 2 - 25 minutos

