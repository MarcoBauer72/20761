
----- Modulo 18: Implementing Transactions

USE Adventureworks
GO


IF OBJECT_ID('PESSOAS','U') IS NOT NULL
DROP TABLE PESSOAS

CREATE TABLE PESSOAS
(	
	 id int UNIQUE not null
	,nome varchar(50) not null
	,email varchar(100)
)

-- SELECT * FROM PESSOAS
-- DELETE PESSOAS


SELECT * FROM PESSOAS


SELECT @@TRANCOUNT


DBCC OPENTRAN;


ROLLBACK


-- TRANSACAO (Chave duplicada)
BEGIN TRAN
	  SET NOCOUNT ON;
		INSERT INTO PESSOAS 
		(id, nome, email)
		VALUES (10,'Peleh','peleh10@fifa.com')

		INSERT INTO PESSOAS 
		(id, nome, email)
		VALUES (5,'5','5a.com')
		   	
		INSERT INTO PESSOAS 
		(id, nome, email)
		VALUES (5,'OUTRAVEZ','5a.com')

  	    COMMIT;
ROLLBACK;

SELECT * FROM PESSOAS
TRUNCATE TABLE PESSOAS

SELECT @@TRANCOUNT
DBCC OPENTRAN;



-- SELECT * FROM PESSOAS
-- DELETE PESSOAS



-- TRANSACAO (Tabela Inexistente)
-- * Problema gravissimo quando o nome da tabela
-- nao existe
BEGIN TRY

BEGIN TRAN
	    SET NOCOUNT ON;
		
		INSERT INTO PESSOAS 
		(id, nome, email)
		VALUES (10,'Peleh','peleh10@fifa.com')

		INSERT INTO PESSOAS 
		(id, nome, email)
		VALUES (5,'5','5a.com')

		BEGIN TRY
		INSERT INTO PESSOAZ 
		(id, nome, email)
		VALUES (4,'OUTRAVEZ','5a.com')
		END TRY
		BEGIN CATCH
		ROLLBACK
		END CATCH

  	    COMMIT;
END TRY
BEGIN CATCH
ROLLBACK;
END CATCH
	
	
-- SELECT * FROM PESSOAS
-- DELETE PESSOAS
SELECT @@TRANCOUNT

DBCC OPENTRAN;



-- TRANSACAO (Comando invalido)
BEGIN TRAN
	    SET NOCOUNT ON;
		INSERT INTO PESSOAS 
		(id, nome, email)
		VALUES (1,'Peleh','peleh10@fifa.com')

		INSERT INTO PESSOAS
		(id, nome, email)
		VALUES (2,'2','5a.com')
		   	
		INSERTT PESSOAS 
		(id, nome, email)
		VALUES (3,'OUTRAVEZ','5a.com')

  	    COMMIT;
ROLLBACK;
	
SELECT @@TRANCOUNT

-- SELECT * FROM PESSOAS
-- DELETE PESSOAS


-- TRANSACAO (Chave duplicada- XACT_ABORT ON)	
-- Especifica se o SQL Server reverte automaticamente a transação atual 
-- quando uma instrução Transact-SQL gera um erro em tempo de execução.
SET XACT_ABORT ON;
BEGIN TRAN
	    SET NOCOUNT ON;

		INSERT INTO PESSOAS 
		(id, nome, email)
		VALUES (10,'Peleh','peleh10@fifa.com')

		INSERT INTO PESSOAS 
		(id, nome, email)
		VALUES (5,'5','5a.com')
		   
		INSERT INTO PESSOAS 
		(id, nome, email)
		VALUES (5,'OUTRAVEZ','5a.com')
			
	  -- É uma função escalar que informa o estado de transação de usuário de uma solicitação em execução atualmente.  
	  -- XACT_STATE indica se a solicitação tem uma transação de usuário ativa e se a transação consegue ser confirmada. 
	  IF (XACT_STATE()) > 0
  	  COMMIT;



--ROLLBACK;
--SET XACT_ABORT OFF;


-- SELECT * FROM PESSOAS
-- DELETE PESSOAS



-- TRANSACAO (Chave duplicada - @@ERROR)	
BEGIN TRAN
	    SET NOCOUNT ON;
		
		INSERT INTO PESSOAS 
		(id, nome, email)
		VALUES (10,'Peleh','peleh10@fifa.com')
		IF @@ERROR > 0 ROLLBACK;

		INSERT INTO PESSOAS 
		(id, nome, email)
		VALUES (5,'5','5a.com')
		IF @@ERROR > 0 ROLLBACK;
		   	
		INSERT INTO PESSOAS 
		(id, nome, email)
		VALUES (5,'OUTRAVEZ','3a.com')
		IF @@ERROR > 0 ROLLBACK;

		COMMIT;



DROP TABLE PESSOAS_ERROR


CREATE TABLE PESSOAS_ERROR
(
NUMBER INT,
SEVERITY  INT,
STAT INT,
PROCED   NVARCHAR(1000),
LINE INT,
MSG  NVARCHAR(1000),
DATA DATETIME,
HOST NVARCHAR(1000),
USERS NVARCHAR(1000)
)

DELETE PESSOAS_ERROR

SELECT * FROM PESSOAS_ERROR

SELECT * FROM PESSOAS

TRUNCATE TABLE PESSOAS


-- TRANSACAO COM TRY CATCH
	BEGIN TRY
		BEGIN TRAN
			--SET NOCOUNT ON;
  
			INSERT INTO PESSOAS 
			(id, nome, email)
			VALUES (11,'Peleh','peleh10@fifa.com')

			INSERT INTO PESSOAS 
			(id, nome, email)
			VALUES (15,'15','15a.com')
		   	
			INSERT INTO PESSOAS 
			(id, nome, email)
			VALUES (15,'OUTRAVEZ','12a.com')
					
		IF @@TRANCOUNT >0 COMMIT;
		
		PRINT 'TODAS INSERCOES COM SUCESSO!!!'
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT >0  ROLLBACK;
		    INSERT INTO PESSOAS_ERROR
			SELECT
   			ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() AS ErrorState,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage,
			GETDATE(),
			HOST_NAME(),
			SYSTEM_USER

			IF ERROR_NUMBER()=2627
			RAISERROR ('Erro de insercao duplicada em campo UNIQUE !!!',10,1);
	END CATCH


	SELECT * FROM PESSOAS_ERROR

--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

--SELECT * FROM PESSOAS (NOLOCK)


-- Exibe a última instrução enviada de um cliente a uma instância do MicrosoftSQL Server
DBCC INPUTBUFFER (58)


SELECT * FROM PESSOAS_ERROR 

-- Lab. 18 - Página 628 ou 817 (PDF)
-- Exercícios 1 e 2 - 20 minutos

