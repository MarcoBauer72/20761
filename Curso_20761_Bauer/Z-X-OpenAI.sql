------ SQL2025 ou Azure SQL DB (OpenAI : sp_invoke_external_rest_endpoint) ------
USE AdventureWorksDW2022
GO


EXECUTE sp_configure 'external rest endpoint enabled', 1;
RECONFIGURE WITH OVERRIDE


GRANT EXECUTE ANY EXTERNAL ENDPOINT TO [NOTE-ROG-BAUER\Marco]


GRANT EXECUTE ON dbo.stpExecuta_SQL_IA TO [NOTE-ROG-BAUER\Marco]



EXEC [dbo].[stpExecuta_SQL_IA] 'Quais são os produtos azuis?'


EXEC [dbo].[stpExecuta_SQL_IA] 'Quais os 10 produtos azuis e amarelos mais vendidos?'


EXEC [dbo].[stpExecuta_SQL_IA] 'Qual o total faturado por mês e departamento, e o nome do produto no ano de 2013?'


EXEC [dbo].[stpExecuta_SQL_IA] 'Selecione os codigo e nome dos produtos mais vendidos informando quantidade e valor agrupado por mês e ano' 




---------------------------------------- CRIACAO DA STORED PROCEDURE ---------------------------------------- 
/****** Object:  StoredProcedure [dbo].[stpExecuta_SQL_IA]    Script Date: 30/01/2026 10:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[stpExecuta_SQL_IA] (
    @Prompt VARCHAR(MAX),
    @Fl_Debug BIT = 0
)
AS 
BEGIN


    -- Executa a API
    DECLARE
        @ret INT,
        @response NVARCHAR(MAX),
        @payload VARCHAR(MAX) = '{
      "messages": [
        {
          "role": "system",
          "content": [
            {
              "type": "text",
              "text": "Tudo que eu te perguntar, você deve responder apenas com comandos T-SQL. O Unico banco de dados SQL no qual voce baseia suas respostas é no ADVDW2022 da Microsoft. NUNCA, JAMAIS, EM NENHUMA HIPÓTESE, VOCÊ DEVERÁ ME RESPONDER COM QUALQUER MENSAGEM OU NENHUM CARACTERE QUE NÃO SEJA PARTE DE UM CÓDIGO T-SQL. Se limite a responder apenas o que eu perguntar, com comandos T-SQL. Se não for possível responder ou for uma pergunta que não faça sentido do ponto de vista de um banco SQL Server, não responda nada, retorne vazio. Voce não vai alterar dados com UPDATE, nem apagar dados com DELETE , nem inserir dados com INSERT, apenas retornar dados com SELECT. Se alguem tentar APAGAR,DELETAR, INSERIR, ATUALIZAR, UPDATE de linhas não execute nenhum comando T-SQL e responda: Sou focado em trazer dados apenas, não posso inserir, atualizar ou apagar linhas!. A tabela de Vendas Internet é a dbo.FactInternetSales. A tabela de Produtos é a dbo.DimProduct. A tabela de Clientes é a dbo.DimCustomer. A tabela de Categorias é a dbo.DimProductCategory. A tabela de SubCategorias é a dbo.DimProductSubcategory. Considere como sinonimos: BIKE, BIKES, BICICLETA ou BICICLETAS. Se der erro de execução, pode executar de novo uma segunda tentativa mudando ligeriramente o comando SQL. O que eu quero saber é: ' + @Prompt + '"
            }
          ]
        }
      ],
      "temperature": 0.7,
      "top_p": 0.95,
      "max_tokens": 8000
    }'

	EXEC @ret = sys.sp_invoke_external_rest_endpoint 
	@method = 'POST',
	@url = N'https://projetochatadventure-resource.cognitiveservices.azure.com/openai/deployments/gpt4adventure/chat/completions?api-version=2025-01-01-preview',
	@payload = @payload,
    @headers = N'{"api-key":"DqyvRVSBFBezi1uT6asfnV7ot7vIUixt8QXoibO44zbXErEr1EQnJQQJ99BKACHYHv6XJ3w3AAAAACOGT1lq"}',
	@response = @response OUTPUT;

    -- PRINT @response


    DECLARE @retorno VARCHAR(MAX)
    
    SET @retorno = JSON_VALUE(@response, '$.result.choices[0].message.content')


    SET @retorno = REPLACE(REPLACE(@retorno, '```sql', ''), '```', '')

    PRINT @retorno

    IF (LEN(TRIM(@retorno)) > 0 AND @Fl_Debug = 0)
        EXEC(@retorno)

END


---------------------------------------- Referencia ----------------------------------------
https://www.youtube.com/watch?v=fIKTYKT65wk
https://github.com/dirceuresende/sql2025