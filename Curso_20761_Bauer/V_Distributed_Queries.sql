
--- PRE-REQUISITO ---


EXEC sp_configure 'show advanced options', '1';
RECONFIGURE WITH OVERRIDE;
GO

-- sp_configure

EXEC sp_configure 'Ad Hoc Distributed Queries', '1';
RECONFIGURE WITH OVERRIDE;
GO

EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'AllowInProcess' , 1
GO

EXEC master . dbo. sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'DynamicParameters' , 1
GO

------------------------------ AD HOC DISTRIBUTED QUERIES ------------------------------

-- Microsoft.Jet.OLEDB.4.0 --
--SELECT * FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0', 
--'Excel 12.0;Database=D:\FONES.XLSX;HDR=YES','select * from [Fones$]')


---- AD-HOC com OPENDATASOURCE
--SELECT * FROM OPENDATASOURCE('Microsoft.Jet.OLEDB.4.0',
--'Data Source=C:\temp\PRODUTOS.XLS;Extended Properties=EXCEL 8.0')...[Plan1$];


---- AD-HOC com OPENROWSET
--SELECT * FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0', 
--'Excel 8.0;Database=D:\FONES.XLSX;HDR=YES', 
--'select * from [Plan1$]')


-- Microsoft.ACE.OLEDB.12.0 --
SELECT * FROM OPENDATASOURCE('Microsoft.ACE.OLEDB.12.0',
'Data Source=D:\FONES.XLSX;Extended Properties=EXCEL 12.0')...[Fones$];


SELECT * FROM OPENDATASOURCE('Microsoft.ACE.OLEDB.12.0',
'Data Source=D:\Fones.xlsx;Extended Properties=EXCEL 12.0')...[Clientes$];


SELECT * FROM OPENDATASOURCE('Microsoft.ACE.OLEDB.12.0',
'Data Source=D:\Fones.xlsx;Extended Properties=EXCEL 12.0')...[Produtos$];


SELECT * FROM OPENDATASOURCE('Microsoft.ACE.OLEDB.12.0',
'Data Source=D:\fones97.xls;Extended Properties=EXCEL 12.0')...[Dia14$];



SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=D:\fones97.xls', 
'select * from [Dia14$] WHERE SEXO = ''F''')

SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=D:\fones.xlsx', 
'select * from [Clientes$] WHERE ID < 4')


----------------------- CRIACAO DE LINKED SERVER COM EXCEL -----------------------
USE [master]
GO

EXEC sp_addlinkedserver
    @server = 'NOVO',
    @srvproduct = 'Excel', 
    @provider = 'Microsoft.ACE.OLEDB.12.0',
    @datasrc = 'D:\FONES.xlsx',
    @provstr = 'Excel 12.0;'
		

EXEC master.dbo.sp_addlinkedserver 
	 @server = N'ANTIGO'
	,@srvproduct=N'EXCEL'
	,@provider=N'Microsoft.ACE.OLEDB.12.0'
	,@datasrc=N'D:\FONES97.XLS'
	,@provstr=N'EXCEL 8.0'
----------------------------------------------------------------------------------


--------------------- LINKED SERVER COM EXCEL -----------------------

SELECT * FROM NOVO...[Produtos$]
SELECT * FROM NOVO...[Clientes$]

SELECT * FROM OPENQUERY(NOVO, 'SELECT * FROM [Produtos$] WHERE IDPRODUTO BETWEEN 40 AND 55')

SELECT * FROM ANTIGO...[Plan1$]



INSERT INTO ANTIGO...[Plan1$] VALUES (14,'MANOEL','DONO','M')
INSERT INTO ANTIGO...[Plan1$] VALUES (15,'VINICIUS','SEGUROS','M')
INSERT INTO ANTIGO...[Plan1$] VALUES (16,'ISRAEL','VENDAS','M')
INSERT INTO ANTIGO...[Plan1$] VALUES (17,'LEANDRA','GERENTE','F')
INSERT INTO ANTIGO...[Plan1$] VALUES (18,'CRISTIANO','GERENTE','M')
INSERT INTO ANTIGO...[Plan1$] VALUES (19,'RODRIGO','GERENTE','M')



SELECT * FROM ANTIGO...[Plan1$]




-- ACE COM XLSX
SELECT * FROM FONES...[Clientes$] 

SELECT * FROM FONES...[Produtos$]



INSERT INTO FONES97...[Plan1$] VALUES (18181818,'XLS','2010','X')
INSERT INTO FONES97...[Plan1$] VALUES (19191919,'XLS','2011','W')
INSERT INTO FONES97...[Plan1$] VALUES (20202020,'XLS','2013','Y')


--------------------------------------------------------------------------

--------------------- IMPORTAR ARQUIVO CSV/TXT ---------------------
USE [10774]
GO

TRUNCATE TABLE dbo.FONES

BULK INSERT dbo.FONES
FROM 'D:\Fones.txt'
WITH
(
  CODEPAGE = '1252',
  FIELDTERMINATOR = ',',
  FIRSTROW = 2,
  CHECK_CONSTRAINTS
) 


BULK INSERT dbo.FONES
FROM 'D:\Fones.txt' WITH (FIRSTROW = 2, FORMATFILE='D:\Fones_Schema.xml');
GO


--------------------- INSERIR IMAGENS VARBINARY ---------------------


UPDATE [Geo].[Estado]
SET Bandeira = 
      (SELECT * FROM OPENROWSET(BULK N'D:\UF\ACRE.PNG', SINGLE_BLOB) AS Bandeira) 
WHERE Sigla = 'AC'

SELECT * FROM [Geo].[Estado]
--------------------- LINKED SERVER COM ORACLE XE -----------------------

SELECT * FROM [ORACLE_XE]..[TMS_SIGNA01].[DIA2611]



--------------------------------------------------------------------------