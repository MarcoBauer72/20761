----- Modulo 2: Introduction to T-SQL Querying
USE Adventureworks
GO

SELECT *
FROM AdventureWorks.PERSON.PERSON


SELECT * FROM PERSON.PERSON

-- Todos os CAMPOS (Nao recomendado o uso de asterisco !)
SELECT * FROM Adventureworks.Person.Person



SELECT [BusinessEntityID]
	,[PersonType]
	,[NameStyle]
	,[Title]
	,[FirstName]
	,[MiddleName]
	,[LastName]
	,[Suffix]
	,[EmailPromotion]
	,[AdditionalContactInfo]
	,[Demographics]
	,[rowguid]
	,[ModifiedDate]
FROM [Person].[Person]




SELECT
 BusinessEntityID
,PersonType
,NameStyle
,Title 
,FirstName
FROM
Person.Person

SELECT
BusinessEntityID, 
PersonType, 
NameStyle  ,
Title, 
FirstName AS LastName
FROM
[Person].[Person]


SELECT
 BusinessEntityID    
,NameStyle
,Title
,FirstName
,MiddleName
,LastName
FROM [Person].[Person] 



SELECT
 BusinessEntityID
,PersonType
,NameStyle
,Title
,FirstName
,MiddleName
,LastName, Suffix EmailPromotion, AdditionalContactInfo, Demographics, rowguid, ModifiedDate
FROM
[Person].[Person]

SELECT BusinessEntityID
	,PersonType
	,NameStyle
	,Title
	,FirstName
	,MiddleName
	,LastName
	,(PersonType + FirstName) COLUNANOVA
	,(FirstName + ' ' + MiddleName + ' ' + LastName) 'NOME COMPLETO'
FROM Person.Person


 
-- Boa Pratica: Selecionar os campos 

SELECT 
	BusinessEntityID, PersonType, NameStyle, Title, FirstName MiddleName, LastName, Suffix, EmailPromotion, AdditionalContactInfo, Demographics, rowguid, ModifiedDate
FROM
	 PERSON.Person 



-- Retorna quantidade de linhas da tabela
SELECT 
	COUNT(1)
FROM 
	Production.Product



	

SELECT [FirstName]
FROM PERSON.PERSON



-- Amostragem
SELECT TOP 50 *
FROM Person.Person -- 19972 linhas



-- Amostragem Porcentagem (Boa identacao !!!)
SELECT TOP 10 PERCENT
	     PS.FirstName
		,PS.MiddleName
		,PS.LastName
		, 'Nome Completo' = PS.FirstName + ' ' + PS.MiddleName + ' ' + PS.LastName
		,PS.Title
FROM Person.Person AS PS


-- Amostragem Variavel
SELECT 
		 BusinessEntityID
		,FirstName
		,MiddleName
		,LastName
		,FirstName + ' ' + LastName 
		,Title
FROM Person.Person
TABLESAMPLE(10)



-- GO (BATCHES)
DECLARE @QUANTIDADE INT = 30
GO -- F5
SELECT @QUANTIDADE -- F5




--GO

SELECT @QUANTIDADE


SELECT * FROM TESTE
SELECT * FROM VTESTE

DROP TABLE TESTE
DROP VIEW VTESTE

CREATE TABLE TESTE (ID INT, NOME VARCHAR(100))
GO
CREATE VIEW VTESTE AS (SELECT * FROM TESTE)





SELECT * FROM TESTE
SELECT * FROM VTESTE


-- Lab. 2  - Página 62 ou 447 (PDF) 
-- Exercícios (1,2 e 3) - 35 minutos


