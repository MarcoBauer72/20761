---------------------------------------- INICIO ------------------------------------------

-- DESAFIO 2 - RETORNAR LINHAS PELA CHAVE SEM REPETIÇÃO E COM ORDENAÇÃO ESPECÍFICA
--			   ORDEM:  PUBLICA -> FISICA-> JURIDICA 

USE [20761]
GO

IF OBJECT_ID('[DESAFIO2]') IS NOT NULL
DROP TABLE [DESAFIO2] 


CREATE TABLE [DESAFIO2]
(
	 CODIGO INT NOT NULL
	,NOME VARCHAR(100)
	,TIPO VARCHAR(50)
	,VALOR DECIMAL(8,2)
)


INSERT INTO [DESAFIO2] VALUES
(1,'MARCO','PUBLICA',1000),(2,'PAULA','FISICA',105.31),(3,'EDUARDO','FISICA',199.22)

INSERT INTO [DESAFIO2] VALUES
(4,'PEDRO','JURIDICA',450.88),(1,'MARCO','FISICA',777.11),(5,'ROBERTO','JURIDICA',991.22)

INSERT INTO [DESAFIO2] VALUES 
(6,'ANDRESSA','PUBLICA',111.22),(4,'PEDRO','FISICA',333.33),(1,'MARCO','JURIDICA',222.44),(3,'EDUARDO','JURIDICA',555.99)


SELECT
	 CODIGO 
	,NOME
	,TIPO
	,VALOR
FROM [DESAFIO2]
ORDER BY CODIGO


-- RESULTSET:  -- ORDEM: PUBLICA -> FISICA-> JURIDICA 

--CODIGO     NOME                TIPO                  VALOR
-----------  ------------------- --------------------- --------------------------------
--	1        MARCO               PUBLICA               1000.00
--	2        PAULA               FISICA                 105.31
--	3        EDUARDO             FISICA                 199.22
--	4        PEDRO               FISICA	                333.33
--	5        ROBERTO             JURIDICA               991.22
--	6        ANDRESSA            PUBLICA                111.22


---------------------------------------- FIM ------------------------------------------


USE [20761]
GO

[dbo].[XSP_DESAFIO2]

-- Não é necessário se utilizar de Stored Procedure!
-- Enviar Resposta para:  mfwbauer72@hotmail.com