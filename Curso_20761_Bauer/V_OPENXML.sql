DECLARE @doc varchar(4000), @docHandle int
SET @doc = '<?xml version="1.0" ?>
            <SalesInvoice InvoiceID="1000" CustomerID="123" OrderDate="2004-03-07">
              <Items>
                <Item ProductCode="12" Quantity="2" UnitPrice="12.99" ProductName="Bike"></Item>
                <Item ProductCode="41" Quantity="1" UnitPrice="17.45" ProductName="Helmet"> </Item>
                <Item ProductCode="2" Quantity="1" UnitPrice="2.99"  ProductName="Water Bottle"></Item>
              </Items>
            </SalesInvoice>'


--PRINT @doc


EXEC sp_xml_preparedocument @docHandle OUTPUT, @doc


--OPENXML using attributes only
--CREATE TABLE #TESTE
--(	ProductCode	int,
--	Quantity	int,
--	UnitPrice	float,
--	ProductName nvarchar(20)
--)


INSERT #TESTE 
SELECT * FROM
OPENXML(@docHandle, '/SalesInvoice/Items/Item', 1)
WITH
(	ProductCode	int,
	Quantity	int,
	UnitPrice	float,
	ProductName nvarchar(20)
)


SELECT * FROM #TESTE


-- OPENXML using elements only
--SELECT * FROM
--OPENXML(@docHandle, '/SalesInvoice/Items/Item', 2)
--WITH
--(	ProductCode	int,
--	Quantity	int,
--	UnitPrice	float,
--	ProductName nvarchar(20))


-- -- OPENXML using either attributes or elements
--SELECT * FROM
--OPENXML(@docHandle, '/SalesInvoice/Items/Item', 3)
--WITH
--(	ProductCode	int,
--	Quantity	int,
--	UnitPrice	float,
--	ProductName nvarchar(20))


-- -- OPENXML using colpattern
--SELECT * FROM
--OPENXML(@docHandle, '/SalesInvoice/Items/Item', 1)
--WITH
--(	InvoiceID	int '../../@InvoiceID',
--	CustomerID	int '../../@CustomerID',
--	OrderDate	datetime '../../@OrderDate',
--	ProductCode	int,
--	Quantity	int,
--	UnitPrice	float,
--	ProductName nvarchar(20) './ProductName')


EXEC sp_xml_removedocument @docHandle
GO
