-------------------- Curso 20-764 - Modulo 4 --------------------

----- Demo 1: Auditing with Temporal Tables

CREATE DATABASE MTC
GO


USE MTC
GO

/*Cria tabela de Pessoas*/
CREATE TABLE Pessoas
( 
	 ID INT NOT NULL
	,NOME VARCHAR(100) NOT NULL
	,SALARIO MONEY
	,CPF CHAR(11)
)

INSERT Pessoas 
VALUES (1,'JOAO',1000,'1484'),(2,'MARIA',2000,'1234')

/*Adiciona colunas de tempo*/
ALTER TABLE dbo.Pessoas
	 ADD DataHoraInicio datetime2(0) GENERATED ALWAYS AS ROW START HIDDEN 
         CONSTRAINT DF_SysStart DEFAULT DATEADD(second, -1, SYSUTCDATETIME()),
	 DataHoraFinal datetime2(0) GENERATED ALWAYS AS ROW END HIDDEN 
         CONSTRAINT DF_SysEnd DEFAULT CONVERT(datetime2 (0), '9999-12-31 23:59:59'),
	 PERIOD FOR SYSTEM_TIME (DataHoraInicio, DataHoraFinal);
GO

SELECT * FROM dbo.Pessoas

SELECT *,DataHoraInicio,DataHoraFinal
 FROM dbo.Pessoas

/*Gera tabela de historico com mesmo schema*/
ALTER TABLE dbo.Pessoas
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Pessoas_Historico));
GO

/*A tabela PAI deve ter chave primaria*/
ALTER TABLE dbo.Pessoas
ADD CONSTRAINT PK_Pessoas_ID PRIMARY KEY CLUSTERED (ID);
GO


/*Gera tabela de historico com mesmo schema*/
ALTER TABLE dbo.Pessoas
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Pessoas_Historico));
GO


SELECT * FROM dbo.Pessoas

SELECT * FROM dbo.Pessoas_Historico

/*Adiciona coluna na tabela*/
ALTER TABLE dbo.Pessoas
	ADD DataNascimento DATE NULL;
GO


SELECT * FROM dbo.Pessoas
SELECT * FROM dbo.Pessoas_Historico

/*Exclui coluna da tabela*/
ALTER TABLE dbo.Pessoas
	DROP COLUMN DataNascimento;
GO

-- Alterando os dados da tabela
UPDATE Pessoas SET SALARIO=2500 WHERE NOME='JOAO'
UPDATE Pessoas SET SALARIO=3300 WHERE NOME='MARIA'

INSERT Pessoas VALUES (3,'PEDRO',2800,1414)
INSERT Pessoas VALUES (4,'ANTONIO',4800,4444)

UPDATE Pessoas SET SALARIO=3800 WHERE NOME='PEDRO'

DELETE Pessoas WHERE NOME='MARIA'

----
SELECT * FROM dbo.Pessoas

SELECT * FROM [dbo].[Pessoas_Historico]



/*Consultando historico completo*/
SELECT * FROM dbo.Pessoas
FOR SYSTEM_TIME ALL
ORDER BY ID, DataHoraInicio DESC

SELECT * --, DataHoraInicio, DataHoraFinal
FROM dbo.Pessoas
FOR SYSTEM_TIME ALL
ORDER BY ID, DataHoraInicio DESC

/*Remove o flag de HIDDEN das colunas de controle temporal*/
ALTER TABLE dbo.Pessoas
ALTER COLUMN DataHoraInicio DROP HIDDEN;

ALTER TABLE dbo.Pessoas
ALTER COLUMN DataHoraFinal DROP HIDDEN;
GO

SELECT * FROM dbo.Pessoas
FOR SYSTEM_TIME ALL
ORDER BY ID, DataHoraInicio DESC


/*Consulta temporal usando BETWEEN*/
SELECT *  --, DataHoraInicio, DataHoraFinal
FROM dbo.Pessoas
FOR SYSTEM_TIME BETWEEN '2016-10-21 13:44:17' AND '2016-10-21 13:49:17'
ORDER BY ID, DataHoraInicio DESC;


/*Consulta temporal usando AS OF*/
DECLARE @now datetime2 = sysutcdatetime()
DECLARE @fromTime datetime2
SET @fromTime = DATEADD (minute, -5, @now)


SELECT * FROM dbo.Pessoas
EXCEPT 
SELECT * FROM dbo.Pessoas
FOR SYSTEM_TIME AS OF @fromTime


/*Consultando historico com CONTAINED IN */
DECLARE @now datetime2 = sysutcdatetime()
DECLARE @fromTime datetime2
SET @fromTime = DATEADD (minute, -5, @now)


SELECT * FROM dbo.Pessoas
FOR SYSTEM_TIME CONTAINED IN (@fromTime, @now)


/*Adiciona o flag de HIDDEN das colunas de controle temporal*/
ALTER TABLE dbo.Pessoas
ALTER COLUMN DataHoraInicio ADD HIDDEN;

ALTER TABLE dbo.Pessoas
ALTER COLUMN DataHoraFinal ADD HIDDEN;
GO

/*Disvincula tabela Historico associada*/
ALTER TABLE dbo.Pessoas SET (SYSTEM_VERSIONING = OFF);

DROP TABLE IF EXISTS dbo.Pessoas;
DROP TABLE IF EXISTS dbo.Pessoas_Historico;