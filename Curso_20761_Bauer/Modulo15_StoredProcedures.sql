----- Modulo 15: Executing Stored Procedures
USE AdventureWorks
GO

/* Não é recomendável iniciar o nome de Stored Procedures com as letras SP
   pois Stored Procedures com SP são do MASTER */

IF OBJECT_ID ('dbo.usp_sel_empregados', 'P') IS NOT NULL
DROP PROCEDURE dbo.usp_sel_empregados
GO


ALTER PROC dbo.usp_sel_empregados
@estadocivil char(1) = NULL
as
begin
Select 
    MaritalStatus
    ,VacationHours 
    ,dbo.fn_calculajuros(VacationHours) AS Reducao
	,'1' AS FIXO
from [HumanResources].[Employee]
where MaritalStatus=@estadocivil OR @estadocivil IS NULL
end

sp_helptext 'dbo.usp_sel_empregados'


EXEC dbo.usp_sel_empregados   


-- S = 144
-- M = 146
-- GERAL = 290

SP_HELPTEXT usp_sel_empregados

usp_sel_empregados



@estadocivil char(1) = NULL
as
begin
Select 
    MaritalStatus
    ,VacationHours 
    ,dbo.fn_calculajuros(VacationHours) AS Reducao
	,'1' AS FIXO
from [HumanResources].[Employee]
where MaritalStatus=COALESCE(@estadocivil,MaritalStatus)
end

sp_helptext usp_sel_empregados


EXEC sp_refreshsqlmodule @name = 'usp_sel_empregados'



 --OR @estadocivil IS NULL         
SP_HELPTEXT usp_sel_empregados

EXEC usp_sel_empregados









--OR @estadocivil IS NULL





--OR @estadocivil is null
--where MaritalStatus = ISNULL(@estadocivil,MaritalStatus)-- or @estadocivil is null

end  
GO

SP_HELPTEXT usp_sel_empregados 


SP_HELPTEXT SP_HELPTEXT

EXEC usp_sel_empregados 





--drop procedure usp_sel_empregados 

SP_HELPTEXT usp_sel_empregados


IF OBJECT_ID ('usp_sel_empregados', 'P') IS NOT NULL
DROP PROCEDURE usp_sel_empregados
GO
CREATE PROCEDURE usp_sel_empregados
@estadocivil char(1) = NULL
WITH RECOMPILE
as
begin
Select 
     E.BusinessEntityID AS CODIGO
     ,COALESCE(P.FirstName,P.MiddleName,P.LastName) AS NOME
    ,E.MaritalStatus AS ESTADO_CIVIL
    ,E.BirthDate AS DATA_NASCIMENTO
from [HumanResources].[Employee] AS E  
LEFT JOIN Person.Person AS P
ON P.BusinessEntityID = E.BusinessEntityID
Where E.MaritalStatus = @estadocivil OR @estadocivil IS NULL

end
GO

usp_sel_empregados 'S'

SP_HELPTEXT  usp_sel_empregados

-- Discovering Parameter defintions
-- Demonstrate using SSMS to learn about stored procedure parameter definitions
/*
1) Connect to instance using Object Browser
2) Expand Databases folder
3) Expand user database
4) Expand Programmability folder
5) Expand Stored Procedures folder
6) Expand desired procedure
7) Expand Parameters folder
8) Point out list of parameters, data type and direction
*/

-- Discover parameters by querying system catalog
DECLARE @proc AS NVARCHAR(255)= N'usp_sel_empregados';
SELECT SCHEMA_NAME(schema_id) AS schema_name
    ,o.name AS object_name
    ,o.type_desc
    ,p.parameter_id
    ,p.name AS parameter_name
    ,TYPE_NAME(p.user_type_id) AS parameter_type
    ,p.max_length
    ,p.precision
    ,p.scale
    ,p.is_output
FROM sys.objects AS o
INNER JOIN sys.parameters AS p ON o.object_id = p.object_id
WHERE o.object_id = OBJECT_ID(@proc)
ORDER BY schema_name, object_name, p.parameter_id;
GO




-- Create simple proc which
-- returns rows via SELECT (no output parameter yet)
IF OBJECT_ID ('Sales.GetCustPhone', 'P') IS NOT NULL
DROP PROCEDURE Sales.GetCustPhone
GO

CREATE PROC Sales.GetCustPhone
(@custid AS INT)
AS
SELECT phone
FROM Sales.Customers
WHERE custid=@custid;
GO

EXEC Sales.GetCustPhone 2


-- Test procedure
SP_HELPTEXT GetCustPhone 
GO

USE TSQL
GO

DROP PROC Sales.GetCustPhone

-- Modify procedure to use an output parameter
CREATE PROC Sales.GetCustPhone
(@custid AS INT,
 @phone AS nvarchar(24) OUTPUT)
AS
SELECT @phone = phone
FROM Sales.Customers
WHERE custid=@custid;
GO

SELECT phone,* 
FROM TSQL.Sales.Customers
WHERE custid= 5   -- 0921-67 89 01

-- Test by declaring a variable to hold
-- the output value, executing the proc and display the value

DECLARE @customerid INT =5, @phonenum NVARCHAR(24)
EXEC Sales.GetCustPhone @custid=@customerid, @phone=@phonenum OUTPUT

SELECT @customerid AS custid, @phonenum AS phone;



DROP TABLE dbo.CLIENTES

CREATE TABLE dbo.CLIENTES (ID INT IDENTITY , NOME VARCHAR(50))

INSERT dbo.CLIENTES VALUES ('BAUER'),('ANDRESSA')

SELECT * FROM dbo.CLIENTES



CREATE PROC dbo.RETORNA_NOME
@CODIGO AS INT  
AS
SELECT NOME FROM dbo.CLIENTES WHERE ID=@CODIGO


EXEC sp_refreshsqlmodule @name = 'dbo.RETORNA_NOME'


EXEC dbo.RETORNA_NOME 2

DROP PROC dbo.RETORNA_ID

CREATE PROC dbo.RETORNA_ID 
(@NOME VARCHAR(50)
,@CODIGO AS INT OUTPUT)
AS
INSERT dbo.CLIENTES VALUES (@NOME)
SELECT @CODIGO = IDENT_CURRENT('dbo.CLIENTES')




DECLARE @PESSOA VARCHAR(50)='EDUARDO', @ID INT 
EXEC dbo.RETORNA_ID @NOME=@PESSOA, @CODIGO=@ID OUTPUT
SELECT @ID



DECLARE  @ID INT, @PESSOA VARCHAR(50)='MARCELO'
EXEC dbo.RETORNA_ID @NOME=@PESSOA, @CODIGO=@ID OUTPUT

SELECT @ID


-- Creating simple procedures with input parameters
-- Declare a parameter to search for category
-- and a parameter to limit the number of results


IF OBJECT_ID ('Production.ProdsByCategory', 'P') IS NOT NULL
DROP PROCEDURE Production.ProdsByCategory
GO

SELECT COUNT(*) FROM Production.Product

DROP PROC Production.ProdsByCategory

CREATE PROC Production.ProdsByCategory
(@numrows AS int, @catid AS int)
 AS
SELECT TOP(@numrows) productid, NAME, ListPrice
FROM Production.Product
WHERE ProductSubcategoryID = @catid;
GO

-- Test procedure

EXEC Production.ProdsByCategory 22, 2;

EXEC Production.ProdsByCategory @numrows = 22, @catid = 2 

DECLARE @numrows INT = 3, @catid INT = 2;

EXEC Production.ProdsByCategory @catid = 2,@numrows = 5

GO
 

----- WITH ENCRYPTION
IF OBJECT_ID ('ProdutoPorCategoria', 'P') IS NOT NULL
DROP PROCEDURE ProdutoPorCategoria
GO


CREATE PROC ProdutoPorCategoria
(@numrows AS int, @catid AS int)

 AS
SELECT TOP(@numrows) productid, productname, unitprice
FROM Production.Products
WHERE categoryid = @catid;
GO

ProdutoPorCategoria 10,2


SP_HELPTEXT ProdutoPorCategoria



/* Stored Procedure Parameter Sniffing */
USE [20761]
GO

-- Cria Tabela dbo.CLIENTES
IF EXISTS(SELECT Table_Name FROM information_schema.TABLES
WHERE table_name='CLIENTES' and table_Type='Base Table')
DROP TABLE dbo.CLIENTES

CREATE TABLE dbo.CLIENTES
(
	 ID INT IDENTITY 
	,NOME VARCHAR(100)
	,PAIS VARCHAR(50)
)

SELECT * FROM  dbo.CLIENTES
TRUNCATE TABLE dbo.CLIENTES

-- Popula tabela dbo.CLIENTES
	DECLARE @id int = 1
	SET NOCOUNT ON;

	WHILE @id <= 10
		BEGIN

			INSERT dbo.CLIENTES (NOME,PAIS) 
			VALUES ('NOME_' + CAST(@id AS VARCHAR(45)),'PORTUGAL')
			
			SET @id += 1;
		END;

	DECLARE @id2 int = 1	
	WHILE @id2 <= 200000
		BEGIN

			INSERT dbo.CLIENTES (NOME,PAIS) 
			VALUES ('NOME_' + CAST(@id2 AS VARCHAR(45)),'BRASIL')
			
			SET @id2 += 1;
		END;	


-- Cria índices
--CREATE CLUSTERED INDEX PK_CLIENTES_ID
--ON dbo.CLIENTES (ID)


CREATE NONCLUSTERED INDEX PK_CLIENTES_PAIS
ON dbo.CLIENTES (PAIS)
 
SELECT * FROM dbo.CLIENTES WHERE PAIS = 'PORTUGAL';
GO
SELECT * FROM dbo.CLIENTES WHERE PAIS = 'BRASIL';
GO


-- Distribuicao de paises na tabela dbo.CLIENTES
SELECT
   PAIS
  ,COUNT(*) AS QTY
FROM dbo.CLIENTES
GROUP BY PAIS

-- BRASIL = 200.000 ROWS
-- PORTUGAL = 10 ROWS

--DROP PROC dbo.USP_Cliente_Pais

CREATE PROC dbo.USP_Cliente_Pais
(@PAIS VARCHAR(50))
AS
(
	SELECT 
	 ID
	,NOME
	,PAIS
	FROM dbo.CLIENTES
	WHERE PAIS = @PAIS
)

DBCC FREEPROCCACHE -- LIMPA O CACHE PARA PROCS
GO
EXEC dbo.USP_Cliente_Pais 'PORTUGAL';
GO
EXEC dbo.USP_Cliente_Pais 'BRASIL';
GO

-- Ao selecionar "Show Execution Plan XML", verificar a tag "ParameterCompiledValue" (ou propriedade do opreador SELECT)

DBCC FREEPROCCACHE -- LIMPA O CACHE PARA PROCS
GO
EXEC dbo.USP_Cliente_Pais 'BRASIL';
GO
EXEC dbo.USP_Cliente_Pais 'PORTUGAL';
GO



ALTER PROC dbo.USP_Cliente_Pais
(@PAIS VARCHAR(50))
WITH RECOMPILE
AS
(
	SELECT 
	 ID
	,NOME
	,PAIS
	FROM dbo.CLIENTES
	WHERE PAIS = @PAIS
)

----------------------------------------------------------------------------------------


/* DYNAMIC SQL EXECUTION */
DECLARE @sql NVARCHAR(4000)
DECLARE @coluna VARCHAR(50)
DECLARE @tabela VARCHAR(50)
DECLARE @id VARCHAR(20)


set @id = '990'

set @coluna = '*'

set @tabela = 'AdventureWorks2022.Production.Product'

set @sql =  'SELECT ' + @coluna 

--set @sql += ' FROM ' + @tabela

set @sql = @sql + ' FROM ' + @tabela

set @sql = @sql + ' WHERE ProductID > ' + @id 
 
--select @sql


--EXEC(@sql)

EXEC sys.sp_executesql @statement = @sql;


 -- NAO EH A MELHOR PRATICA (NAO GERA PLANO DE EXECUCAO)
 --EXEC(@sql)

-- GERA PLANO DE EXECUCAO
EXEC sys.sp_executesql @statement = @sql;


SP_HELPTEXT sp_executesql

SP_HELPTEXT SP_HELPTEXT

SP_HELPTEXT SP_DEPENDS 'Production.Product'

-- Lab. 15 - Página 557 ou 789
-- Exercícios 1,2 e 3 - 35 minutos
