----- Modulo 8: Using Built-In Functions
USE [Adventureworks];
GO


SELECT @@VERSION

SELECT @@SERVERNAME

SELECT HOST_NAME()

SELECT @@LANGUAGE

SELECT DB_NAME() AS [Current Database];

SET LANGUAGE BRAZILIAN

SELECT 1/0

-- Funcoes escalares
SELECT ABS(-1.2), ABS(0.0), ABS(1.0);


-- -2147483648



USE Adventureworks
GO

-- Conversão explícita com CAST e CONVERT: 
SELECT SYSDATETIME()
PRINT SYSDATETIME()

SELECT CAST(SYSDATETIME() AS VARCHAR(10));
SELECT CAST(SYSDATETIME() AS INT);


SELECT CONVERT(VARCHAR(10), SYSDATETIME());
SELECT CONVERT(INT, SYSDATETIME()); -- RETORNA DATETIME2


SELECT GETDATE()+1 -- RETORNA DATETIME

-- 2018-05-05 11:48:20.760

-- USAR CONVERT DE DATA PARA TEXTO E VICE-VERSA QUANDO NECESSÁRIO MÁSCARA
-- PARA TODAS OUTRAS CONVERSOES USAR CAST
SELECT  CONVERT(VARCHAR(10), GETDATE()+1, 103) AS BRA ;


SELECT  CONVERT(VARCHAR(20), GETDATE()+1 ,110) AS USA;


-- ISNUMERIC: Retorna 1 se o parametro passado for numerico
SELECT ISNUMERIC('SQL') AS isnmumeric_result;

SELECT ISNUMERIC(10) AS isnumeric_result;

SELECT ISNUMERIC('33.44') AS isnumeric_result;

SELECT ISNUMERIC('33,44') AS isnumeric_result;

SELECT ISNUMERIC('10E5') AS isnumeric_result;



---- PARSE (Comando T-SQL 2012)
-- Formato nao valido no padrao Americano = ERRO
SELECT PARSE('21/12/2012' AS datetime2 USING 'en-US') AS parse_result;

-- Format valido no padrao Britanico entao CONVERTE
SELECT PARSE('21/12/2012' AS DATETIME2(5) USING 'en-GB') AS parse_result; 

SET LANGUAGE brazilian

SELECT @@LANGUAGE

SET LANGUAGE British; -- ano, mes, dia
SELECT PARSE('12/13/2010' AS datetime2) AS Result;


SET LANGUAGE English; -- ano, dia, mes
SELECT PARSE('12/13/2010' AS datetime2) AS Result;


SELECT PARSE('SQLServer' AS datetime2 USING 'en-US') AS parse_result;



-- TRY_PARSE e TRY_CONVERT (Comandos T-SQL 2012)
SELECT TRY_PARSE('14/10/2014' AS datetime2 USING 'en-US') AS try_parse_result;

SELECT TRY_PARSE('10/11/2014' AS datetime2 USING 'en-GB') AS try_parse_result;

SELECT TRY_PARSE('02//2014' AS datetime2 USING 'en-US') AS try_parse_result;

SELECT ISNULL(TRY_PARSE('SQLServer' AS DATETIME2(7) USING 'en-US'),'19000101') AS try_parse_result;


SELECT TRY_CONVERT(datetime2, '10/14/2014',110) AS try_convert_result

SELECT TRY_CONVERT(datetime2, 'SQLServer',103) AS try_convert_result


-- IIF (Comando T-SQL 2012) 
SELECT IIF(1=1,'CHUCHU','BANANA')

SELECT IIF(2>3,'True','XPTO')




SELECT 	
	 productid
	,ListPrice
	,IIF(ListPrice > 89.99, 'CARO','BARATO') AS pricepoint
FROM 
	Production.Product
ORDER BY ListPrice DESC


-- CHOOSE (Comando T-SQL 2012) 

SELECT CHOOSE(2,'Primeira','XYZ','Terceira')



SELECT CHOOSE(31,'Primeira','Segunda','Terceira','QUARTA')


-- Filtrando por NULL
SELECT 
	--Title
	ISNULL(Title,'N/A') AS TITULO
FROM 
	Person.Person



WHERE Title IS NULL

--CREATE TABLE PESSOAS
--( IDPESSOA INT
--,TITLE VARCHAR(10) SPARSE
--)


UPDATE PERSON.Person
SET Title = NULL
WHERE BusinessEntityID = 3


SELECT 
	 FirstName
	,MiddleName
	,LastName
	,FirstName + MiddleName + LastName AS CONCATENADO
    ,(ISNULL(FirstName,'') + ISNULL(MiddleName,'') + ISNULL(LastName,'')) AS NOMECOMPLETO
	,CONCAT(FirstName,MiddleName,LastName) AS CONCAT_NOMECOMPLETO
	,CONCAT(1,2,3) AS SOMA -- BY CAUE
FROM Person.Person

--UPDATE Person.Person
--SET Suffix = 'Mr.'
--WHERE BusinessEntityID = 10

-- NULLIF
SELECT
	PersonType
	,BusinessEntityID
	,Title
	,Suffix
	,NULLIF (isnull(Title,'na'),Suffix) AS COMPARACAO
FROM Person.Person


SELECT
	PersonType
	,BusinessEntityID
	,Title
	,Suffix
	,NULLIF (ISNULL(Title,'ESQ. NULO'), ISNULL(Suffix, '')) AS COMPARACAO
FROM Person.Person

--UPDATE Person.Person 
--SET Suffix = 'Mr.'
--WHERE BusinessEntityID = 6

--UPDATE Person.Person 
--SET FirstName = NULL
--WHERE BusinessEntityID = 8


-- COALESCE
SELECT 
PersonType
	,BusinessEntityID
	,FirstName
	,MiddleName
	,LastName
	,COALESCE (MiddleName, FirstName,  LastName)
FROM Person.Person


--UPDATE Person.Person 
--SET LastName = NULL
--WHERE BusinessEntityID =3

DROP TABLE TESTE

CREATE TABLE TESTE
(
ID INT
,NOME VARCHAR(20)
,APELIDO VARCHAR(20) 
,SOBRENOME VARCHAR(20)
, 
)
--DROP TABLE TESTE

INSERT INTO TESTE
VALUES (1,'MARCO',NULL,'BAUER'),(2,'JOSÉ','ZÉ','SILVA'),(3,NULL, NULL, 'RODRIGUES')


INSERT INTO TESTE
VALUES (4,NULL,NULL,NULL)




SELECT
 -- APELIDO
 --,NOME
 --,SOBRENOME
 COALESCE(APELIDO, NOME, SOBRENOME,'desconhecido') AS [COALESCE]
FROM TESTE


-- Lab. 8  - Página 297 ou 717 (PDF)
-- Exercícios (1,2 e 3) - 60 minutos

