----- Modulo 20: Querying SQL Server Metadata

USE Adventureworks
GO

SELECT  
   CONNECTIONPROPERTY('net_transport') AS net_transport,
   CONNECTIONPROPERTY('protocol_type') AS protocol_type,
   CONNECTIONPROPERTY('auth_scheme') AS auth_scheme,
   CONNECTIONPROPERTY('local_net_address') AS local_net_address,
   CONNECTIONPROPERTY('local_tcp_port') AS local_tcp_port,
   CONNECTIONPROPERTY('client_net_address') AS client_net_address 


SELECT dec.local_net_address
FROM sys.dm_exec_connections AS dec
WHERE dec.session_id = @@SPID;


SELECT c.local_net_address
FROM sys.dm_exec_connections AS c
WHERE c.session_id = @@SPID;


-- Mostrar IP da placa de rede local
SELECT TOP(1) c.local_net_address
FROM sys.dm_exec_connections AS c
WHERE c.local_net_address IS NOT NULL;


SELECT @@VERSION

EXEC SP_DATABASES
GO

EXEC sys.sp_helpdb;
GO


EXEC sys.sp_helpsort;
GO

EXEC SP_HELPTEXT  SP_DATABASES

EXEC SP_HELPTEXT SP_HELPTEXT

SP_HELP N'[Person].[Person]'





SELECT * FROM SYS.objects

SELECT * FROM SYS.SYSobjects


-- METADATA
SELECT * FROM sys.objects
where name like 'Pro%' AND TYPE = 'U'

-- USAR DE PREFERENCIA sys.sysobjects
SELECT * FROM sys.sysobjects
where name like 'Pro%' AND XTYPE = 'U'


SELECT * FROM sys.tables where name like 'Pro%';


SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE UPPER(DATA_TYPE) = 'DATETIME'

SP_HELPTEXT sys.tables



-- DROP TABLE COM METADATA
IF EXISTS (SELECT 1 FROM tempdb..sysobjects WHERE name LIKE '##Pessoas')
DROP TABLE [##Pessoas]
CREATE TABLE ##Pessoas
(
   ID int
   ,TIPO nchar(2)
   ,NOME nvarchar(200)
)

	
IF OBJECT_ID('tempdb..##Pessoas') IS NOT NULL
DROP TABLE ##Pessoas 

CREATE TABLE ##Pessoas
(
   ID int
   ,TIPO nchar(2)
   ,NOME nvarchar(200)
)



INSERT INTO ##Pessoas 
SELECT 
	BusinessEntityID
	,PersonType
	,FirstName + ' ' + LastName
FROM PERSON.PERSON 
WHERE FirstName LIKE 'E%'

select * from ##Pessoas



-- DMV - Dynamic Management Views 
SELECT *   
--cpu_count, physical_memory_in_bytes, sqlserver_start_time
FROM sys.dm_os_sys_info


--SP_HELPTEXT '[sys].[dm_os_sys_info]'

--[Production].[Product]
-- STORED PROCEDURES
sp_columns @table_name = N'Product',
   		   @table_owner = N'%';
	
sp_columns @table_name = N'%',
   		   @table_owner = N'Production';
		   		
SP_HELPTEXT sp_columns


SELECT * FROM SYS.COLUMNS 
WHERE OBJECT_ID = OBJECT_ID('Production.Product')
 
 --1973582069
 		
SELECT * FROM SYS.TABLES WHERE NAME='Product'
SELECT * FROM SYS.COLUMNS WHERE OBJECT_ID = 1973582069
SELECT * FROM SYS.sysobjects	

SELECT SO.name , SO.xtype,* 
FROM SYS.COLUMNS AS SC
JOIN SYS.sysobjects AS SO
ON SC.object_id = SO.id
ORDER BY SO.name
	
				
-- DATABASES DA INSTANCIA
sp_databases			
			
			
SP_DEPENDS [Production.Product]


SP_HELPTEXT uspGetBillOfMaterials 

SP_HELPTEXT [Production.vProductAndDescription]

SP_HELPTEXT SP_DEPENDS

SP_HELPTEXT uspGetWhereUsedProductID

SP_SPACEUSED [PRODUCTION.PRODUCT]

SP_HELPTEXT SP_SPACEUSED

------- PESQUISANDO PELA EXISTENCIA DE UM OBJETO : TABELA, PROCEDURE,... ----------

DROP TABLE NOMES
-- PELA :  SYSOBJECTS
IF EXISTS (SELECT 1 FROM sysobjects WHERE name LIKE 'NOMES')
BEGIN
PRINT 'OK'
END
ELSE
PRINT 'NAO EXISTE'


 

IF EXISTS (SELECT 1 FROM tempdb..sysobjects WHERE name LIKE '#Pessoas%')
PRINT 'OK'



-- COM: OBJECT_ID
IF (SELECT OBJECT_ID('FONES','U')) IS NOT NULL
	BEGIN
 	  PRINT 'TABELA JA EXISTE - DROP'
   	--  DROP TABLE FONES
	END
ELSE
	BEGIN
	    PRINT 'TABELA CRIADA'
     	CREATE TABLE FONES (ID INT)
	END

SELECT * FROM FONES

SELECT OBJECT_ID('<database name>..<your table name>')

Object type. Can be one of these object types: 
C = CHECK constraint
D = Default or DEFAULT constraint
F = FOREIGN KEY constraint
L = Log
FN = Scalar function
IF = Inlined table-function
P = Stored procedure
PK = PRIMARY KEY constraint (type is K)
RF = Replication filter stored procedure 
S = System table
TF = Table function
TR = Trigger
U = User table
UQ = UNIQUE constraint (type is K)
V = View
X = Extended stored procedure




-- COM : INFORMATION_SCHEMA_TABLES
-- FORMA RECOMENDADA DE VERIFICAR A PRE-EXISTENCIA DE 
-- TABELA NAO TEMPORARIA (PERSISTIDA)
if exists(select Table_Name from information_schema.TABLES
where table_name='Fones' and table_Type='Base Table')
DROP TABLE Fones

CREATE TABLE Fones
(
id int
,nome varchar(100)
,fone varchar(150)
)

SELECT * FROM FONES

-- Step 2: --System Views and Functions
-- View server settings
SELECT  * --name, value, value_in_use, description
FROM sys.configurations
ORDER BY name;

SP_CONFIGURE 'show advanced options',1
RECONFIGURE WITH OVERRIDE;

SP_CONFIGURE 'xp_cmdshell',0
RECONFIGURE WITH OVERRIDE;

-- View list of databases on instance
SELECT  name ,
        database_id ,
        create_date ,
        collation_name ,
        user_access ,
        user_access_desc ,
        state ,
        state_desc 
FROM sys.databases;

-- Step 3: Two alternatives to using system views

-- List user-created tables, show that system views 
-- can be joined like user views and tables
SELECT  s.name AS schemaname,
		t.name AS tablename ,
        t.object_id ,
        type_desc ,
        create_date
FROM sys.tables AS t
JOIN sys.schemas AS s
ON t.schema_id = s.schema_id
ORDER BY schemaname, tablename;

-- Step 4: Use a system function to resolve the schema ID
SELECT  SCHEMA_NAME(schema_id) AS schemaname,
		name AS tablename ,
        object_id ,
        type_desc ,
        create_date
FROM sys.tables
ORDER BY schemaname, tablename;

-- Step 5 List data types
SELECT * FROM sys.types
SELECT * FROM sys.columns ORDER BY object_id, column_id

-- Step 6: List columns in a table with corresponding data type names

SELECT  OBJECT_NAME(object_id) AS tablename,
        name AS columnname,
        column_id ,
		TYPE_NAME(user_type_id) AS typename,
        max_length ,
        collation_name        
FROM sys.columns
WHERE object_id = object_id('Sales.Customers');




-- Step 7: Show INFORMATION_SCHEMA views
SELECT  TABLE_CATALOG,TABLE_SCHEMA,TABLE_NAME,TABLE_TYPE
FROM    INFORMATION_SCHEMA.TABLES;

SELECT VIEW_CATALOG, VIEW_SCHEMA, VIEW_NAME, TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.VIEW_COLUMN_USAGE;

-- Step 8: Common system metadata functions
-- Compare @@VERSION to SERVERPROPERTY
-- Show students other options for SERVERPROPERTY
-- in Books Online: http://msdn.microsoft.com/en-us/library/ms174396.aspx
SELECT @@VERSION AS SQL_Version;
SELECT SERVERPROPERTY('ProductVersion') AS version;
SELECT SERVERPROPERTY('Collation') AS collation;




-- Step 2: Use System Stored Procedures (not supported on Azure)
-- Execute a stored procedure with no parameters
EXEC sys.sp_databases; 



-- Espaco usado pelo DATABASE ou pela TABELA
SP_SPACEUSED 

SP_SPACEUSED 'Production.Product'

SP_SPACEUSED 'Person.Person'




-- Execute a stored procedure with a single parameters
EXEC sys.sp_help N'Person.Person';



-- Execute a stored procedure which accepts
-- multiple parameters
EXEC sys.sp_tables 
	@table_name = '%', 
	@table_owner = 'Sales';

-- Step 3: Return system language information
EXEC sys.sp_helplanguage;

-- Step 4: List stored procedures
-- Note: TSQL2012 db has no user procedures
-- so this will show system procedures only
-- For a result which includes user procedures,
-- Switch to AdventureWorks2008R2 if available
USE Adventureworks;
GO
EXEC sys.sp_stored_procedures;

-- Step 5: Optional demo to show filtering by schema
USE Adventureworks;
GO
EXECUTE sys.sp_stored_procedures @sp_owner='HumanResources';




-- Step 2:  List system objects
SELECT  name, type, type_desc
FROM sys.system_objects
WHERE name LIKE 'dm_%'
ORDER BY name;

USE master ;
GO
-- Step 3:  List DMVs
SELECT  name, type, type_desc
FROM sys.system_objects
WHERE name LIKE 'dm_%'
ORDER BY name;

-- Step 4:  Show information about all active user connections and internal tasks.
SELECT  session_id ,
        login_time ,
        host_name ,
        program_name ,
        login_name ,
        status ,
        cpu_time ,
        memory_usage ,
        last_request_start_time ,
        last_request_end_time ,
        reads ,
        writes ,
        logical_reads ,
        is_user_process ,
        language ,
        date_format ,
        row_count
FROM    sys.dm_exec_sessions
WHERE   program_name IS NOT NULL ;


-- Step 5: Display sessions grouped by logged-in users 
SELECT  login_name ,
        COUNT(session_id) AS session_count
FROM    sys.dm_exec_sessions
GROUP BY login_name;

--Step 6: Show dependencies between objects
--Which objects referenced the 
--Sales.Orders table?
USE TSQL;
GO
SELECT referencing_schema_name, referencing_entity_name, referencing_class_desc
FROM sys.dm_sql_referencing_entities ('Sales.Orders', 'OBJECT');

SP_WHO



SP_WHO2


SP_CONFIGURE 'xp_cmdshell',1
RECONFIGURE --WITH OVERRIDE; 

CREATE TABLE #DIRETORIO (NOME VARCHAR(MAX))

DROP #DIRETORIO

INSERT #DIRETORIO
xp_cmdshell 'CLS'

SELECT * FROM #DIRETORIO


-- Lab. 20 - Página 527 ou 783
-- Exercícios 1,2 e 3 - 40 minutos