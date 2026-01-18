---------------------------------------- INICIO ------------------------------------------


-- DESAFIO 1 - RETORNAR PARTE DA STRING
-- 'http://microsoft.com.br/developers/pt-br/downloads'
-- 'http://ibm.com/usa/teste'
-- 'http://apple.com.br/validate/accounts/pt-pt/void'
-- 'http://android.com.br/validate/test/brazil/accounts/am-fm/ultimo'
-- 'http://hp.com.br/calculators/invention/anyone/amazing/ac-dc/last'



-- Criar Select que retorna a penúltima parte para qualquer uma das 5 URLs acima.

-- RESULTSET:
-- pt-br
-- usa
-- pt-pt

---------------------------------------- FIM ------------------------------------------


USE [20461]
GO

XSP_DESAFIO1 'http://microsoft.com.br/developers/pt-br/downloads';

XSP_DESAFIO1 'http://ibm.com/usa/teste';

XSP_DESAFIO1 'http://apple.com.br/validate/accounts/pt-pt/void';

XSP_DESAFIO1 'http://android.com.br/validate/test/brazil/accounts/am-fm/ultimo'

XSP_DESAFIO1 'http://hp.com.br/calculators/invention/anyone/amazing/ac-dc/last'



-- * Dica: Uma maneira é usando o comando REVERSE
-- Não é necessário se utilizar de Stored Procedure !
-- Enviar Resposta para:  mfwbauer72@hotmail.com
-- Não tem barra (slash) no final da URL