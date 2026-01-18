----- Modulo 7: Using DML to Modify Data

USE Adventureworks
GO


DROP TABLE PESSOAS
DROP TABLE PESSOAS_A

--SELECT @@VERSION
drop TABLE PESSOAS

-- CRIA TABELA NOVA
CREATE TABLE PESSOAS
(	
	 id int  IDENTITY NOT NULL
	,nome varchar(50) NOT NULL
	,email varchar(100)
)


INSERT PESSOAS (nome)
VALUES ('Jose'), ('Pedro'),('Ana')


SELECT * FROM PESSOAS



-- INSERCAO SIMPLES
INSERT PESSOAS (email) 
VALUES ('Marco@teste.com.br')

SELECT * FROM PESSOAS

INSERT PESSOAS
VALUES ('Torres', 'j@t.com'), ('Pedro','pb@ka.com.br'),('Ana','am@ka.com')


-- INSERCAO MULTIPLA
INSERT PESSOAS  (email, nome)
VALUES ('j@t???.com','Torres')

select * from pessoas

INSERT INTO PESSOAS (nome)
VALUES ('CENTOTREZE'), ('Pedro'),('Ana')

INSERT PESSOAS (ID, NOME)
VALUES (7, 'sete')

-- No momento q se muda o comportamento
-- natural do identity ,nao esquecer o
-- comando para desligar (linha 61)
SET IDENTITY_INSERT PESSOAS ON
GO

INSERT INTO PESSOAS (ID, NOME, EMAIL) 
VALUES (500,'CENTO E UM','cem@microsoft')



SET IDENTITY_INSERT PESSOAS OFF
GO


SELECT * FROM PESSOAS

--TRUNCATE TABLE PESSOAS

-- NAO FAZ RESEED DO CAMPO IDENTITY
DELETE PESSOAS

-- FAZ RESEED DO CAMPO IDENTITY
--TRUNCATE TABLE PESSOAS

SELECT IDENT_CURRENT('PESSOAS')




-- RESEED DO CAMPO IDENTITY
DBCC CHECKIDENT (PESSOAS, reseed, 0)	




TRUNCATE TABLE PESSOAS


SELECT COUNT(*)  FROM PESSOAS
SELECT *  FROM PESSOAS

DROP TABLE PESSOAS

TRUNCATE TABLE PESSOAS

DELETE PESSOAS

-- INSERT INTO
SET NOCOUNT ON;
INSERT X100
UPDATE X50
DELETE X80


SET NOCOUNT OFF;

INSERT PESSOAS
VALUES ('Torres', 'j@t.com'), ('Pedro','pb@ka.com.br'),('Ana','am@ka.com')

INSERT PESSOAS (nome)
SELECT CONCAT(firstname , ' ', MiddleName ,' ' ,LastName)
FROM Person.Person

SET NOCOUNT OFF;


SELECT * FROM PESSOAS
WHERE NOME = 'Alex C Adams'

SELECT * FROM PESSOAS_LETRA_A


DROP TABLE PESSOAS_LETRA_A
-- SELECT INTO
SELECT CONCAT(firstname , ' ', MiddleName ,' ' ,LastName) AS NOMECOMPLETO
INTO PESSOAS_LETRA_A
FROM Person.Person
WHERE FirstName LIKE 'A%' -- and  ((FirstName + ' ' + MiddleName + ' ' + LastName) is not null)

SELECT * FROM dbo.PESSOAS_LETRA_A

SELECT * FROM PESSOAS
WHERE NOME = 'ALEX C ADAMS'



-- DELETE PARAMETRIZADO (!!! Cuidado !!!)
DELETE PESSOAS_LETRA_A
WHERE NOMECOMPLETO = 'Alex C Adams'



SELECT * FROM PESSOAS
WHERE NOME = 'AMANDA P ADAMS'


-- UPDATE SEM PARAMETRO (!!! Cuidado !!!)
UPDATE PESSOAS 
SET email = 'email@microsoft.com.br' 

--select * from pessoas


-- UPDATE COM WHERE 
UPDATE PESSOAS
SET email = 'ANABB@MICROSOFT.com.br', NOME ='Ana Barbosa'
WHERE UPPER(nome) = 'AMANDA P ADAMS'





select * from pessoas WHERE ID=19995

WHERE UPPER(nome) = 'Ana Barbosa'


-- UPDATE DE 2 OU MAIS CAMPOS SIMULTANEAMENTE
UPDATE PESSOAS
SET email = 'ana@microsoft.com.br', nome = 'Ana Barbosa'
WHERE ID=17

SELECT * FROM PESSOAS WHERE ID=17


-- UPDATE COM OUTPUT
select * from PESSOAS_LOG

DROP TABLE PESSOAS_LOG


CREATE table PESSOAS_LOG  (
					id int
					,nome varchar(50)
					,email_antigo varchar(100)
					,email_novo varchar(100)
					);




UPDATE PESSOAS 
SET email = 'NOVO@microsoft.com.br'
OUTPUT deleted.id
	   ,deleted.nome
	   ,deleted.email
	   ,inserted.email
INTO PESSOAS_LOG
WHERE ID = 19995

SELECT * FROM PESSOAS 
WHERE nome = 'Ana Barbosa'

SELECT * FROM PESSOAS_LOG


SELECT * FROM PESSOAS WHERE nome LIKE 'J%'

SELECT COUNT(*) FROM PESSOAS WHERE nome LIKE 'J%'


-- DELETE COM OUTPUT
DELETE PESSOAS 
OUTPUT DELETED.* 
WHERE nome LIKE 'J%'





-- COM USUARIO E ESTACAO
DROP TABLE PESSOAS_LOG

CREATE table PESSOAS_LOG
 (id int
  ,nome varchar(50)
  ,email varchar(100)
  ,estacao varchar(100)
  ,usuario varchar(100)
  ,data datetime2(3)
 )

SELECT * FROM PESSOAS_LOG
 
 
SELECT * FROM PESSOAS WHERE NOME LIKE 'N%'

DELETE PESSOAS 
OUTPUT DELETED.*, HOST_NAME(), SYSTEM_USER, SYSDATETIME()  
INTO PESSOAS_LOG
WHERE nome LIKE 'N%'


SELECT * FROM PESSOAS_LOG


DELETE PESSOAS

SELECT * FROM PESSOAS


DROP TABLE CLIENTES

CREATE TABLE CLIENTES
(
	 ID INT IDENTITY
	,NOME VARCHAR(50)
)

INSERT INTO CLIENTES
VALUES ('JOAO'),('MARIA')

SELECT * FROM CLIENTES

SELECT MAX(ID) FROM CLIENTES

DELETE CLIENTES WHERE ID= 2

CREATE DATABASE [20761]
-- MERGE (15/05/2015)
USE [20761]
GO

if exists(Select Table_Name from information_schema.TABLES
where table_name='Pessoas_DW' and table_Type='Base Table')
DROP TABLE Pessoas_DW

if exists(Select Table_Name from information_schema.TABLES
where table_name='Pessoas_ERP' and table_Type='Base Table')
DROP TABLE Pessoas_ERP


CREATE TABLE dbo.Pessoas_ERP
(
	 EmployeeID int PRIMARY KEY
	,EmployeeName varchar(10)
)

CREATE TABLE dbo.Pessoas_DW
(
	 EmployeeID int PRIMARY KEY
	,EmployeeName varchar(10)
	,Apagado bit
)

GO
INSERT dbo.Pessoas_ERP(EmployeeID, EmployeeName) Values(102, 'Estefano');
INSERT dbo.Pessoas_ERP(EmployeeID, EmployeeName) Values(103, 'Bob');
INSERT dbo.Pessoas_ERP(EmployeeID, EmployeeName) Values(104, 'Steve');


INSERT dbo.Pessoas_DW(EmployeeID, EmployeeName, Apagado) VALUES(100, 'Mary',0);
INSERT dbo.Pessoas_DW(EmployeeID, EmployeeName, Apagado) VALUES(101, 'Sara',0);
INSERT dbo.Pessoas_DW(EmployeeID, EmployeeName, Apagado) VALUES(102, 'Stefano',0);

GO

SELECT * FROM Pessoas_ERP
SELECT * FROM Pessoas_DW


MERGE Pessoas_DW AS T
USING Pessoas_ERP AS S
ON (T.EmployeeID = S.EmployeeID) 
WHEN NOT MATCHED --BY TARGET  -- LINHAS QUE NAO EXISTAM NO DESTINO
    THEN INSERT(EmployeeID, EmployeeName, Apagado) VALUES(S.EmployeeID, S.EmployeeName,0)
WHEN MATCHED				-- LINHAS QUE EXISTAM EM AMBOS
    THEN UPDATE SET T.EmployeeName = S.EmployeeName
WHEN NOT MATCHED BY SOURCE  -- LINHAS QUE NAO EXISTAM NA ORIGEM
    THEN DELETE 
OUTPUT $action, inserted.*, deleted.*;


--UPDATE SET T.Apagado = 1 
-- RETORNANDO ULTIMO VALOR DE COLUNA IDENTITY
-- @@IDENTITY = Retorna o último valor de identidade gerado em qualquer tabela da sessão atual. Não é limitada a um escopo específico. 
-- SCOPE_IDENTITY = Retornam o último valor de identidade gerado em qualquer tabela da sessão atual.  Entretanto, só retorna o valor dentro do escopo atual.
-- IDENT_CURRENT = Não é limitado por escopo e sessão, mas a uma tabela especificada.  

CREATE TABLE IDENT (ID INT IDENTITY, NOME VARCHAR(100))
CREATE TABLE IDENT2 (ID INT IDENTITY, NOME VARCHAR(100))


INSERT IDENT VALUES ('MARCO');
INSERT IDENT2 VALUES ('MARCO');

SELECT @@IDENTITY

SELECT SCOPE_IDENTITY()

SELECT IDENT_CURRENT('IDENT')
SELECT IDENT_CURRENT('IDENT2')





-- SEQUENCE (COMANDO NOVO DO T-SQL 2012)

DROP TABLE ALUNOS
DROP TABLE PROFESSORES

-- Define a sequence
CREATE 
	SEQUENCE dbo.InvoiceSeqDIA14 AS INT 
	START WITH 1
	INCREMENT BY 1;


-- Retorna o proximo valor disponivel da sequencia
SELECT	NEXT VALUE FOR dbo.InvoiceSeqDIA14;

CREATE TABLE ALUNOS
(ID INT
,NOME VARCHAR(100)
)

CREATE TABLE PROFESSORES
(ID INT
,NOME VARCHAR(100)
)

DECLARE @I INT

SELECT  @I = NEXT VALUE FOR dbo.InvoiceSeqDIA14
INSERT ALUNOS VALUES (@I,'ANA')
SELECT  @I = NEXT VALUE FOR dbo.InvoiceSeqDIA14
INSERT PROFESSORES VALUES (@I,'JOAO')
SELECT  @I = NEXT VALUE FOR dbo.InvoiceSeqDIA14
INSERT ALUNOS VALUES (@I,'BEATRIZ')
SELECT  @I = NEXT VALUE FOR dbo.InvoiceSeqDIA14
INSERT PROFESSORES VALUES (@I,'PAULA')



SELECT * FROM ALUNOS
SELECT * FROM PROFESSORES

-- Lab. 7  - Página 297 ou 475 (PDF)
-- Exercícios (1,2 e 3) - 60 minutos