----- FILETABLE -----
Use master;
GO

EXEC sp_configure filestream_access_level,0;
GO
RECONFIGURE;
GO

-- O recurso FileTable oferece suporte para namespace de arquivo do Windows 
-- e compatibilidade de aplicativos do Windows com dados de arquivo armazenados 
-- no SQL Server. O FileTable permite que um aplicativo integre seus componentes 
-- de armazenamento e gerenciamento de dados e forneça serviços integrados do SQL Server, 
-- inclusive pesquisa de texto completo e pesquisa semântica, em dados não estruturados e metadados. 

-- Em outras palavras, você pode armazenar arquivos e documentos em tabelas especiais no SQL Server, 
-- denominadas FileTables, mas acessá-los a partir de aplicativos do Windows como se eles estivessem 
-- armazenados no sistema de arquivos, sem fazer alterações nos seus aplicativos cliente. 

-- O recurso FileTable se baseia na tecnologia FILESTREAM do SQL Server.

-- Benefícios do recurso FileTable:
-- Os objetivos do recurso FileTable incluem o seguinte: 
-- •Compatibilidade com APIs do Windows para dados de arquivos armazenados em um banco de dados do SQL Server. 
--  A compatibilidade com APIs do Windows inclui o seguinte: 
-- ?Acesso de streaming não transacional e atualizações in loco para dados FILESTREAM. 
-- ?Um namespace hierárquico de diretórios e arquivos. 
-- ?Armazenamento de atributos de arquivo, como data de criação e data de modificação. 
-- ?Suporte para APIs de gerenciamento de arquivos e diretórios do Windows. 
-- •Compatibilidade com outros recursos do SQL Server que incluem ferramentas de gerenciamento, serviços e 
--  recursos de consulta relacional em dados de atributo de arquivo e FILESTREAM. 

-- Com isso, as FileTables removem uma barreira significativa ao uso do SQL Server para o armazenamento e 
-- gerenciamento de dados não estruturados que residem atualmente como arquivos em servidores de arquivos. 
-- As empresas podem mover esses dados de servidores de arquivos para FileTables para aproveitar a administração 
-- integrada e os serviços fornecidos pelo SQL Server. Ao mesmo tempo, podem manter a compatibilidade de aplicativos 
-- do Windows para seus aplicativos do Windows existentes que consultam esses dados como arquivos no sistema de arquivos. 


-- 1) Habilitar FILESTREAM no serviço MSSQLSERVER através do SSMS -> OPTIONS.
   -- SQL server Configuration Manager (botao direito no database engine -> properties)

-- 2) Habilitar FILESTREAM no nível de instância com SP_CONFIGURE

USE master;
GO

EXEC sp_configure filestream_access_level, 2;
GO
RECONFIGURE;
GO

-- 3) Criar o database de Filestream
CREATE DATABASE FilesDemo
ON PRIMARY (NAME = Data1, FILENAME='D:\DemoFiles\Data.mdf'),
   FILEGROUP FilestreamGroup1 CONTAINS FILESTREAM(NAME=Data2, FILENAME='D:\DemoFiles\Filestream')
   LOG ON (NAME=Log1, FILENAME='D:\DemoFiles\Log.ldf')
WITH FILESTREAM (NON_TRANSACTED_ACCESS = FULL, DIRECTORY_NAME=N'FilestreamData')
GO

-- 4) Criar a tabela Filetable
USE FilesDemo
GO
CREATE TABLE FileStore As FileTable
WITH
(FileTable_Directory = 'Documents')
GO

SELECT DB_NAME (database_id),directory_name
FROM sys.database_filestream_options;
GO


USE FilesDemo;
GO
SELECT file_stream.GetFileNamespacePath() AS [Relative Path] FROM dbo.FileStore;
GO

-- Copiar arquivos para \\localhost\MSSQLSERVER\FilestreamData\Documents

-- Query FileTable
SELECT [name], FileTableRootPath() + file_stream.GetFileNamespacePath() [Full Path]
FROM FileStore
GO

-- Create full-text catalog
CREATE FULLTEXT CATALOG documents_catalog
GO

-- Get index ID for FileTable PK
SELECT [name] FROM sys.sysindexes WHERE [name] LIKE 'PK__FileStor%'   -- Obter o nome do indicia e colar abaixo

-- Create full-text index
CREATE FULLTEXT INDEX ON FileStore
    ([name] Language 1033, 
	 [file_stream] TYPE COLUMN
	 [file_type] Language 1033)
KEY INDEX PK__FileStor__5A5B77D57B646E3D  -- Colar nome do indice obtido acima
ON documents_catalog
GO

--DROP FULLTEXT INDEX ON FileStore

-- Procura documentos com as palavras "Business Intelligence" juntas
SELECT [name], FileTableRootPath() + file_stream.GetFileNamespacePath() [Full Path]
FROM FileStore
WHERE FREETEXT(file_stream,'Business Intelligence')

-- Procura documentos com o nome "Pedro"
SELECT [name], FileTableRootPath() + file_stream.GetFileNamespacePath() [Full Path]
FROM FileStore
WHERE FREETEXT(file_stream,'Pedro')


-- Procura documentos de São Paulo
SELECT [name], FileTableRootPath() + file_stream.GetFileNamespacePath() [Full Path]
FROM FileStore
WHERE FREETEXT(file_stream,'São Paulo')


-- Producra documentos do Rio de Janeiro
SELECT [name], FileTableRootPath() + file_stream.GetFileNamespacePath() [Full Path]
FROM FileStore
WHERE CONTAINS(file_stream,'Rio')


-- Procura documentos de Fevereiro
SELECT [name], FileTableRootPath() + file_stream.GetFileNamespacePath() [Full Path]
FROM FileStore
WHERE FREETEXT(file_stream,'Fevereiro')


-- Procura documentos de Abril
SELECT [name], FileTableRootPath() + file_stream.GetFileNamespacePath() [Full Path]
FROM FileStore
WHERE CONTAINS(file_stream,'Abril')


-- Procura documentos com palavra Business proxima da palavra ABOBRINHA
SELECT [name], FileTableRootPath() + file_stream.GetFileNamespacePath() [Full Path]
FROM FileStore
WHERE CONTAINS(file_stream, 'NEAR((Business, ABOBRINHA), 15)')


-- Referências:
-- http://technet.microsoft.com/pt-br/library/gg509097.aspx
-- http://technet.microsoft.com/pt-br/library/ff929144.aspx
-- http://social.technet.microsoft.com/wiki/pt-br/contents/articles/9535.sql-server-2012-filetable-fulltext-semantic.aspx
-- http://dougbert.com/blog/post/Creating-a-Full-Text-Index-on-a-FileTable-in-SQL-Server-2012.aspx
-- https://www.simple-talk.com/sql/database-administration/full-text-searches-on-documents-in-filetables/
-- https://social.msdn.microsoft.com/Forums/en-US/09b2aa08-282a-4289-9d00-dd31701023eb/getting-started-with-filestreamfile-table-full-text-search?forum=sqlsetupandupgrade



----------------------------------------- FIM -----------------------------------------
