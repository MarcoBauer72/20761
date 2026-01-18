----- Modulo 17: Implementing Error Handling

USE Adventureworks
GO

IF OBJECT_ID('tempdb..#T') IS NOT NULL
DROP TABLE #T

CREATE TABLE #T 
(
	 ID INT UNIQUE
	,NOME VARCHAR(100)
)

INSERT INTO #T  VALUES (1, 'MICROSOFT')


SELECT * FROM #T

TRUNCATE TABLE PESSOAS

BEGIN TRY
	SELECT * FROM PESSOAS
	PRINT 'OK'
END TRY
BEGIN CATCH
	PRINT 'ERRO'
END CATCH




SELECT * FROM #T
--TRUNCATE TABLE #T 

-- TRY/CATCH 
SELECT MAX(message_id)
FROM SYS.messages



WHERE message_id = 2627

SET LANGUAGE BRAZILIAN;

BEGIN TRY
    DECLARE @TEXTO VARCHAR(100) = 'DE NOVO'
	INSERT INTO #T  VALUES (1, @TEXTO)
	PRINT 'INSERIU COM SUCESSO!!!'
END TRY
BEGIN CATCH
	PRINT 'ERRO: Entrou no bloco CATCH';
	--INSERT INTO #T  VALUES (2, 'TRES')
	INSERT INTO #T  VALUES ((SELECT MAX(ID)+1 FROM #T), @TEXTO);
	THROW
END CATCH


-- Retornando informacao do erro
BEGIN TRY
	INSERT INTO #T  VALUES (1, 'MARCO')
END TRY
BEGIN CATCH
	SELECT 
		ERROR_NUMBER() AS errnum,
		ERROR_MESSAGE() AS errmsg,
		ERROR_SEVERITY() AS errsev,
		ERROR_PROCEDURE() AS errproc,
		ERROR_LINE() AS errline;
END CATCH;


-- Retornando o erro sem THROW
BEGIN TRY
	SET NOCOUNT ON;
	INSERT INTO #T  VALUES (1, 'MICRO')
END TRY
BEGIN CATCH
	PRINT 'Code inside CATCH is beginning'
	PRINT 'Error: ' + CAST(ERROR_NUMBER() AS VARCHAR(255));
	SET NOCOUNT OFF;
END CATCH



--SET LANGUAGE English

SET LANGUAGE Brazilian


-- Com THROW 
SET LANGUAGE  Brazilian
BEGIN TRY
	SET NOCOUNT ON;
	INSERT INTO #T  VALUES (1, 'MB');
END TRY
BEGIN CATCH
	
	PRINT 'Code inside CATCH is beginning'
	PRINT 'Error: ' + CAST(ERROR_NUMBER() AS VARCHAR(255));
	THROW;
	SET NOCOUNT OFF;
	SET LANGUAGE English
END CATCH


SELECT * FROM SYS.messages
WHERE MESSAGE_ID = 2627

SELECT MAX(MESSAGE_ID) FROM SYS.messages

-- RAISERROR
--SET NOCOUNT ON;
SELECT * FROM #T 

-- INDENPENDENTE DA SEVERIDADE CONTINUA A EXECUCAO
-- DO CODIGO APOS O RAISERROR
BEGIN TRY
	INSERT INTO #T  VALUES (1, 'MICROSOFT');
END TRY
BEGIN CATCH
	 IF ERROR_NUMBER()= 2627
		RAISERROR ('Violacao de campo do tipo UNIQUE !!!',
			11,  -- 10 INFORMACAO, 11 ao 16 - ERRO COM CONTINUACAO, 17 - ERRO E ABORTA A EXECUCAO
			1 
			);
	 	INSERT INTO #T  VALUES ((SELECT MAX(ID)+1 FROM #T), 'MICROSOFT');
END CATCH

SET NOCOUNT OFF;

SP_HELPTEXT [SYS.messages]

SP_DEPENDS [SYS.messages]

SELECT MAX(MESSAGE_ID)
FROM
SYS.messages


SELECT *
FROM 
[SYS].[messages] 
WHERE message_id = 50001

ORDER BY message_id DESC

SP_HELPTEXT sp_addmessage

sp_addmessage @msgnum = 50001
              ,@severity = 10
              ,@msgtext = 'ERROR DUPLICITY %s'
			  ,@lang = 'English';
GO

sp_addmessage @msgnum = 50001
              ,@severity = 10
              ,@msgtext = 'Erro no SQL de tentativa de insercao de chave duplicada !!!'
			  ,@lang = 'Brazilian';
GO

SET LANGUAGE Brazilian

RAISERROR (50001 -- Message id
           ,10 -- Severity
           ,1 -- State
           ,''
		   ); 


GO

SET LANGUAGE Brazilian
BEGIN TRY
	INSERT INTO #T  VALUES (1, 'MICROSOFT');
END TRY
BEGIN CATCH
	 IF ERROR_NUMBER()= 2627
		RAISERROR (50001 -- Message id
           ,11 -- Severity
           ,1 -- State
           ,''
		   );
 INSERT INTO #T  VALUES ((SELECT MAX(ID)+1 FROM #T), 'PROXIMO');
END CATCH

--SP_HELPTEXT sp_addmessage

SELECT * FROM #T


sp_dropmessage @msgnum = 50001, @lang = 'Brazilian';
GO


sp_dropmessage @msgnum = 50001, @lang = 'English';
GO




-- Lab. 17 - Página 605 ou 809 (PDF)
-- Exercícios 1 e 2 - 35 minutos
