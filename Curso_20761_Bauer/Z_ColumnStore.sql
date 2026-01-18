----- COLUMN STORE -----

-- Quando utilizamos o ColumnStore Index ,  a tabela na qual receberá o índice se tornará “Read-Only, 
-- sendo assim os dados armazenados neste índice possuirão uma compressão de colunas ao invés de 
-- compressão de linhas, com isso temos um grande ganho de performance e armazenamento. 
-- Além disso, temos um novo modo de execução dentro do QO (Query Optimizer), o “batch mode”, que 
-- pode realizar um processamento de 1.000 linhas enquanto no nossso modelo convencional teriamos um  
-- processamento linha-a-linha e dependendo dos fatores e filtros que forem utilizados na consulta, 
-- esse índice poderá se beneficiar da nova tecnologia “segment elimination” tendo um algoritmo que pode 
-- eliminar os dados que não serão selecionados (segmentados) reduzindo assim grandemente o impacto de I/O.


--Pontos Positivos:
--• Batch Mode = Blocos de 1.000 linhas que são retornados a consulta ao invés de linha-a-linha. 
--• Algoritmo de Redução de Custo de I/O, tornando a consulta assim mais eficiente. 
--• “Segment  Elimination” de acordo com os filtros passados ao QO, possibilitará trazer a consulta mais rápido, isso porque o mecanismo possibilita a quebra da partição em diversas partes selecionando assim os dados de uma forma mais eficiente. 

--Pontos Negativos:
--• Algumas operações não são possíveis no novo modo “Batch Mode” como: Outer Joins, Join entre strings, NOT IN, IN, EXISTS e agregações escalares. 
--• Se houver pressão na memória ou um grande uso de paralelismo, provavelmente o QO utilizirá o modo linha-a-linha para a execução da consulta. 

--  Candidatos à ColumnStore Indexes
--• Tabelas contendo milhões a bilhões de registros (Fact Tables). 
--• Scan x Seek (ColumnStore Indexes não suporta operações de Seek, somente Scan). 
--• Operações de agregação como SUM(), AVG, joins e filtros utilizados na pesquisa. 

--  Definições do ColumnStore Index
--• Só podem ser índices non-clustered e non-unique. 
--• Não podem ser criados em Views, Indexes Views e Sparse Columns. 
--• Não podem possuir relacionamento, logo não podem atuar como Primary Key ou Foreign Key. 
--• Sem conceito da opção INCLUDE na criação do índice non-clustered. 
--• Sem permissão da utilização do operador Sort ou seja ordernação dos dados ASC ou DESC. 
--• Varchar(MAX), NVarchar(Max), Lob, FileStream, Numeric e Decimal com precisão >18 e Datetimeoffset >2 não são permitidos. 


USE AdventureWorksDW
GO

-- Remove todos os elementos do cache do plano, remove um plano específico do cache do plano, 
-- por meio da especificação de um identificador de plano ou identificador SQL ou remove todas
-- as entradas de cache com um pool de recursos especificado. 
DBCC FREEPROCCACHE

SET STATISTICS TIME ON

SET STATISTICS IO ON

-- Para visualizar os índices criados da tabela dbo.FactProductIventory
-- EXEC sp_helpindex 'FactProductInventory'

-- SELECT COUNT(*) FROM dbo.FactProductInventory

SELECT DP.EnglishProductName AS NomeProduto,
DP.Color AS Cor,
D.CalendarYear AS Ano,
AVG(F.UnitCost) AS Preco,
D.WeekNumberOfYear AS QtdSemamas,
SUM(F.UnitsOut) AS QtdUnidades
FROM FactProductInventory AS F
INNER JOIN DimProduct AS DP
ON F.ProductKey = DP.ProductKey
INNER JOIN DimDate AS D
ON D.DateKey = F.DateKey
WHERE WeekNumberOfYear BETWEEN 20 AND 50
GROUP BY DP.EnglishProductName, DP.Color, D.WeekNumberOfYear, D.CalendarYear


-- Observa-se que o Hash Match é utilizado quando é requerido ao QO (Query Optimizer)
-- operações de agregações, joins e para retirar valores duplicados da consulta, o que, 
-- neste caso ilustrado acima, está custando 41% do plano total da consulta.

-- Criando o ColumnStore Index na tabela dbo.FactProductIventory.
CREATE NONCLUSTERED COLUMNSTORE INDEX CSIidxNCL_FactProductInventory
ON dbo.FactProductInventory
(
     ProductKey,
     DateKey,
     UnitCost,
     UnitsOut
)


-- Forcando ignorar o indice columnstore
SELECT DP.EnglishProductName AS NomeProduto,
DP.Color AS Cor,
D.CalendarYear AS Ano,
AVG(F.UnitCost) AS Preco,
D.WeekNumberOfYear AS QtdSemamas,
SUM(F.UnitsOut) AS QtdUnidades
FROM FactProductInventory AS F
INNER JOIN DimProduct AS DP
ON F.ProductKey = DP.ProductKey
INNER JOIN DimDate AS D
ON D.DateKey = F.DateKey
WHERE WeekNumberOfYear BETWEEN 20 AND 50
GROUP BY DP.EnglishProductName, DP.Color, D.WeekNumberOfYear, D.CalendarYear
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);

 
-- Usando o indice columnstore
SELECT DP.EnglishProductName AS NomeProduto,
DP.Color AS Cor,
D.CalendarYear AS Ano,
AVG(F.UnitCost) AS Preco,
D.WeekNumberOfYear AS QtdSemamas,
SUM(F.UnitsOut) AS QtdUnidades
FROM FactProductInventory AS F
INNER JOIN DimProduct AS DP
ON F.ProductKey = DP.ProductKey
INNER JOIN DimDate AS D
ON D.DateKey = F.DateKey
WHERE WeekNumberOfYear BETWEEN 20 AND 50
GROUP BY DP.EnglishProductName, DP.Color, D.WeekNumberOfYear, D.CalendarYear



-- OBJETO SE TORNOU READ-ONLY
BEGIN TRANSACTION
SELECT @@TRANCOUNT

UPDATE dbo.FactProductInventory
     SET UnitCost =  UnitCost * 2
WHERE DateKey = '20050704'

ROLLBACK TRANSACTION
GO


-- Desabilitando o índice e tentando novamente….
ALTER INDEX CSIidxNCL_FactProductInventory
ON dbo.FactProductInventory DISABLE
GO


BEGIN TRANSACTION
SELECT @@TRANCOUNT
UPDATE dbo.FactProductInventory
     SET UnitCost =  111
WHERE ProductKey = 520 AND DateKey = '20050630'


SELECT *
FROM dbo.FactProductInventory
WHERE ProductKey = 520 AND DateKey = '20050630'

COMMIT TRANSACTION

ROLLBACKTRANSACTION


-- Habilitando o índice e tentando novamente….
ALTER INDEX CSIidxNCL_FactProductInventory
ON dbo.FactProductInventory REBUILD
GO


-- Forçando ou inibindo a utilização do ColumnStore Index, veremos agora que o dado foi atualizado com sucesso.
SELECT *
FROM dbo.FactProductInventory WITH(INDEX(CSIidxNCL_FactProductInventory))
WHERE ProductKey BETWEEN 500 AND 1000;


SELECT *
FROM dbo.FactProductInventory
WHERE ProductKey BETWEEN 500 AND 1000
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);



-- Referência:
-- http://social.technet.microsoft.com/wiki/contents/articles/9251.entendendo-o-column-store-index-no-sql-server-2012-pt-br.aspx