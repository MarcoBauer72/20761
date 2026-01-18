----- FILETABLE -----


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

-- 2) Habilitar FILESTREAM no nível de instância com SP_CONFIGURE

	EXEC sp_configure filestream_access_level, 2;
	RECONFIGURE;
	
-- 3) Criar regras no FIREWALL para as portas 139 e 445

-- 4) Criar um banco de dados habilitado para FILESTREAM

	CREATE DATABASE FS 
	ON
	PRIMARY ( NAME = FS1,
	    FILENAME = 'c:\FILESTREAM\FSTREAM.mdf'),
	FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM( NAME = FS3,
	    FILENAME = 'c:\FILESTREAM\filestream1')
	LOG ON  ( NAME = FSLOG1,
	    FILENAME = 'c:\FILESTREAM\FSTREAMlog1.ldf')
	GO


-- 5) Habilitar o acesso não transacional em nível de banco de dados

	SELECT DB_NAME(database_id), non_transacted_access, non_transacted_access_desc
	FROM sys.database_filestream_options;
	GO

	SELECT DB_NAME ( database_id ), directory_name
	FROM sys.database_filestream_options;
	GO

	ALTER DATABASE FS
	SET FILESTREAM ( NON_TRANSACTED_ACCESS = FULL, DIRECTORY_NAME = N'FS' ) 


-- 6) Criar uma FileTable

	USE FS 
	GO

	--CREATE TABLE Documentos AS FileTable;
	--GO


	CREATE TABLE Documentos AS FileTable
	    WITH ( 
	          FileTable_Directory = 'DocumentosSQL',
	          FileTable_Collate_Filename = database_default
	         );
	 	  GO
	 
	 
-- 7) Arrastar os documentos para a pasta e acessar por T-SQL
	 
	 SELECT * FROM Documentos


-- Referências:
-- http://technet.microsoft.com/pt-br/library/gg509097.aspx
-- http://technet.microsoft.com/pt-br/library/ff929144.aspx


