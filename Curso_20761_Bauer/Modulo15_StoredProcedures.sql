----- Modulo 15: Executing Stored Procedures
USE Adventureworks
GO

/* Não é recomendável iniciar o nome de Stored Procedures com as letras SP
   pois Stored Procedures com SP são do MASTER */

IF OBJECT_ID ('usp_sel_empregados', 'P') IS NOT NULL
DROP PROCEDURE usp_sel_empregados
GO


alter PROC usp_sel_empregados
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




SP_HELPTEXT usp_sel_empregados

usp_sel_empregados







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



DROP TABLE CLIENTES

CREATE TABLE CLIENTES (ID INT IDENTITY, NOME VARCHAR(50))

INSERT CLIENTES VALUES ('MARCO'),('ANDRESSA')

SELECT * FROM CLIENTES



CREATE PROC RETORNA_NOME
@CODIGO AS INT  
AS
SELECT NOME FROM CLIENTES WHERE ID=@CODIGO


EXEC sp_refreshsqlmodule @name = 'RETORNA_NOME'


EXEC RETORNA_NOME 2

DROP PROC RETORNA_ID

ALTER PROC RETORNA_ID 
(@NOME VARCHAR(50)
,@CODIGO AS INT OUTPUT)
AS
INSERT CLIENTES VALUES (@NOME)
SELECT @CODIGO = IDENT_CURRENT('CLIENTES')




DECLARE @PESSOA VARCHAR(50)='MARCELO', @ID INT =0 --???
EXEC RETORNA_ID @NOME=@PESSOA, @CODIGO=@ID OUTPUT

SELECT @ID



DECLARE  @ID INT, @PESSOA VARCHAR(50)='MARCELO'
EXEC RETORNA_ID @NOME=@PESSOA, @CODIGO=@ID OUTPUT

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
DECLARE @numrows INT = 3, @catid INT = 2;

EXEC Production.ProdsByCategory 6, 2;

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
USE [20461]
GO

-- Cria Tabela Clientes
IF EXISTS(SELECT Table_Name FROM information_schema.TABLES
WHERE table_name='Clientes' and table_Type='Base Table')
DROP TABLE Clientes

CREATE TABLE dbo.Clientes
(
	 ID INT IDENTITY
	,NOME VARCHAR(100)
	,PAIS VARCHAR(50)
)


-- Popula tabela Clientes
	DECLARE @id int = 1
	DECLARE @id2 int = 1

	SET NOCOUNT ON;

	WHILE @id <= 10
		BEGIN

			INSERT dbo.Clientes (NOME,PAIS) 
			VALUES ('NOME_' + CAST(@id AS VARCHAR(45)),'PORTUGAL')
			
			SET @id += 1;
		END;
	
	WHILE @id2 <= 200000
		BEGIN

			INSERT dbo.Clientes (NOME,PAIS) 
			VALUES ('NOME_' + CAST(@id2 AS VARCHAR(45)),'BRASIL')
			
			SET @id2 += 1;
		END;	


-- Cria índice
CREATE CLUSTERED INDEX PK_CLIENTES_NOME
ON dbo.Clientes (NOME)

-- Distribuicao de paises na tabela Clientes
SELECT
   PAIS
  ,COUNT(*) AS QTY
FROM dbo.Clientes
GROUP BY PAIS

-- BRASIL = 200.000 ROWS
-- PORTUGAL = 10 ROWS


CREATE PROC [dbo].USP_Cliente_Pais
(@PAIS VARCHAR(50))
AS
(
	SELECT 
	 ID
	,NOME
	,PAIS
	FROM dbo.Clientes
	WHERE PAIS = @PAIS
)

DBCC FREEPROCCACHE -- LIMPA O CACHE PARA PROCS
GO

EXEC dbo.USP_Cliente_Pais 'PORTUGAL'


EXEC dbo.USP_Cliente_Pais 'BRASIL'



/* DYNAMIC SQL EXECUTION */
DECLARE @sql NVARCHAR(4000)
DECLARE @coluna VARCHAR(50)
DECLARE @tabela VARCHAR(50)
DECLARE @id VARCHAR(20)


set @id = '990'

set @coluna = '*'

set @tabela = 'Adventureworks.Production.Product'

set @sql =  'SELECT ' + @coluna 


--set @sql += ' FROM ' + @tabela

set @sql = @sql + ' FROM ' + @tabela

set @sql = @sql + ' WHERE ProductID > ' + @id 
 
--EXEC(@sql)




 -- NAO EH A MELHOR PRATICA (NAO GERA PLANO DE EXECUCAO)
 --EXEC(@sql)

-- GERA PLANO DE EXECUCAO
EXEC sys.sp_executesql @statement = @sql;


SP_HELPTEXT sp_executesql

SP_HELPTEXT SP_HELPTEXT

SP_HELPTEXT SP_DEPENDS 'Production.Product'

-- Lab. 15 - Página 557 ou 789
-- Exercícios 1,2 e 3 - 35 minutos