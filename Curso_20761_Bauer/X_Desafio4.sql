---------------------------------------- INICIO ------------------------------------------
USE [20761]
GO

-- DESAFIO 4 - RETORNAR MULTIPLOS VALORES EM UM UNICO CAMPO 
IF OBJECT_ID('DESAFIO4') IS NOT NULL
DROP TABLE DESAFIO4 


CREATE TABLE DESAFIO4
(
ID INT
,PRODUTO VARCHAR(100)
,OBS VARCHAR(200)
)


INSERT INTO DESAFIO4 VALUES
(1,'BOLA','Macia'),(2,'NOTEBOOK','Rápido'),(3,'CELULAR','Moderno')


INSERT INTO DESAFIO4 VALUES
(4,'BOLA','Profissional'),(5,'NOTEBOOK','Caro'),(6,'CELULAR','Bonito')


INSERT INTO DESAFIO4 VALUES
(7,'BOLA','Nova'),(8,'NOTEBOOK','Ultrafino'),(9,'CELULAR','Leve')


SELECT 
	 ID
	,PRODUTO
	,OBS
FROM DESAFIO4


-- RESULTSET:

--PRODUTO                OBS
------------------------ --------------------------------
--BOLA                   Macia,Profissional,Nova
--CELULAR                Moderno,Bonito,Leve
--NOTEBOOK               Rápido,Caro,Ultrafino


---------------------------------------- FIM ------------------------------------------


USE [20761]
GO

[dbo].[XSP_DESAFIO4]


-- * DICA:  SELECT  CAMPO1, CAMPO2 FROM TABELA1 FOR XML 
-- Não é necessário se utilizar de Stored Procedure!
-- Enviar Resposta para:  mfwbauer72@hotmail.com