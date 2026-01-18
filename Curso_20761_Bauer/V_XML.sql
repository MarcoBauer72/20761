-- RAW mode
USE AdventureWorks2008R2
SELECT ProductID, Name, ListPrice as valor 
FROM Production.Product
FOR XML RAW('Produto'), root('Produtos'), elements

 -- ELEMENTS with RAW mode
USE AdventureWorks2008R2
SELECT ProductID, Name, ListPrice
FROM Production.Product
FOR XML RAW, ELEMENTS

-- Named element in RAW mode
SELECT ProductID, Name, ListPrice
FROM Production.Product
FOR XML RAW('Product')

-- root element
SELECT ProductID, Name, ListPrice
FROM Production.Product
FOR XML RAW, ROOT('Products')

-- Join in RAW mode
SELECT Category.Name CategoryName, Product.ProductID, Product.Name
FROM Production.ProductSubCategory Category
JOIN Production.Product Product
ON Product.ProductSubCategoryID = Category.ProductSubCategoryID
ORDER BY Category.Name, Product.ProductID
FOR XML RAW

-- AUTO Mode
SELECT ProductID, Name, ListPrice
FROM Production.Product Product
FOR XML AUTO, root('Produtos'), elements

-- Join in AUTO mode
SELECT Category.Name CategoryName, Product.ProductID, Product.Name
FROM Production.ProductSubCategory Category
JOIN Production.Product Product
ON Product.ProductSubCategoryID = Category.ProductSubCategoryID
ORDER BY Category.Name, Product.ProductID
FOR XML AUTO

-- Nested XML with TYPE
SELECT ProductID, 
       Name, ListPrice,
       (SELECT ReviewerName, Comments
        FROM Production.ProductReview ProductReview
        WHERE ProductReview.ProductID = Product.ProductID
        FOR XML AUTO, ELEMENTS, TYPE)
FROM Production.Product Product
WHERE ProductID > 795
FOR XML AUTO

-- EXPLICIT Mode
SELECT	1 AS TAG,
		NULL AS Parent,
		ProductID AS [Product!1!ProductID],
		Name AS [Product!1]
FROM Production.Product
FOR XML EXPLICIT

-- Nesting in EXPLICIT Mode
SELECT	1 AS TAG, -- pk
		NULL AS Parent, -- fk
		ProductID AS [Product!1!ProductID],
		Name AS [Product!1!ProductName!Element],
		NULL AS [Review!2!Reviewer],
		NULL AS [Review!2]
FROM Production.Product
WHERE ProductID > 795
UNION ALL
SELECT	2,
		1,
		p.ProductID,
		NULL,
		r.ReviewerName AS [Review!2!Reviewer],
		r.Comments AS [Review!2]
FROM Production.ProductReview r
JOIN Production.Product p
ON  p.ProductID = r.ProductID
WHERE p.ProductID > 795
ORDER BY [Product!1!ProductID]
FOR XML EXPLICIT

-- PATH mode
SELECT 	EmployeeID "@EmpID", 
       	FirstName  "EmpName/First", 
       	LastName   "EmpName/Last"
FROM	Person.Contact INNER JOIN	HumanResources.Employee 
			ON Person.Contact.ContactID = Employee.ContactID
FOR XML PATH('pessoa')




SELECT ProductID AS "@ProductID",
       Name AS "*",
       Size AS "Description/@Size",
       Color AS "Description/text()"
FROM Production.Product
ORDER BY Name
FOR XML PATH('Product')
