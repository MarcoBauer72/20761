---------------------------------------- INICIO ------------------------------------------
USE [20761]
GO

-- DESAFIO 3 - REMOVER LINHAS REPETIDAS --
IF OBJECT_ID('DESAFIO3') IS NOT NULL
DROP TABLE DESAFIO3 


CREATE TABLE DESAFIO3
(
 ID INT
,NOME VARCHAR(100)
)


INSERT INTO DESAFIO3
VALUES
(1,'MARIA'),(1,'MARY'),(1,'MA'),(2,'JOSÉ'),(2,'JÔ'),(2,'ZÉ')


INSERT INTO DESAFIO3
VALUES
(3,'PEDRO'),(3,'PETER'),(4,'BEATRIZ'),(4,'BIA'),(4,'BEA'),(4,'BEATRIZ')


-- Para cada ID retornar apenas 1 nome.  

-- RESULTSET:

--ID          NOME
------------- -------------------------------------------------------------------------
--1           MARIA
--2           ZÉ
--3           PEDRO
--4           BIA

---------------------------------------- FIM ------------------------------------------

USE [20761]
GO

[dbo].[XSP_DESAFIO3]


-- Não é necessário se utilizar de Stored Procedure!
-- Enviar Resposta para:  mfwbauer72@hotmail.com