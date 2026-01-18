
-- FULLTEXTSEARCH
--Is a predicate used in a WHERE clause to search columns containing 
--character-based data types for values that match the meaning 
--and not just the exact wording of the words in the search condition. 
--When FREETEXT is used, the full-text query engine internally performs 
--the following actions on the freetext_string, assigns each term a weight, 
--and then finds the matches. 
--Separates the string into individual words based on word boundaries (word-breaking).
--Generates inflectional forms of the words (stemming).
--Identifies a list of expansions or replacements for the terms based on matches in the thesaurus. 


USE AdventureWorks2008R2;
GO
EXEC sp_configure 'show advanced option', '1';


sp_fulltext_database 'enable'


CREATE FULLTEXT CATALOG [ADV_CAT] AS DEFAULT;
GO


CREATE FULLTEXT INDEX ON Production.ProductDescription(Description) 
KEY INDEX [PK_ProductDescription_ProductDescriptionID];
GO

sp_fulltext_column 'Production.ProductDescription','Description','add'

--Activate the index
sp_fulltext_table 'Production.ProductDescription','activate'



USE AdventureWorks2008R2;
GO
SELECT *
FROM Production.ProductDescription
WHERE FREETEXT (Description, 'vital safety components' );
--WHERE FREETEXT (Description, 'comfortable' );
GO

USE AdventureWorks2008R2;
GO
SELECT *
FROM Production.ProductDescription
WHERE Description LIKE '%vital%safety%components%'



SELECT * FROM
Production.ProductDescription
WHERE 
FREETEXT (Description, 'riding' );


-- CONTAINS
--Is a predicate used in a WHERE clause to search columns containing character-based 
--data types for precise or fuzzy (less precise) matches to single words and phrases, 
--the proximity of words within a certain distance of one another, or weighted matches. 
--In SQL Server, you can use four-part names in CONTAINS or FREETEXT full-text predicates 
--to execute queries against linked servers.
--CONTAINS can search for: 
--A word or phrase.
--The prefix of a word or phrase.
--A word near another word.
--A word inflectionally generated from another (for example, the word drive is the inflectional stem of drives, drove, driving, and driven).
--A word that is a synonym of another word using a thesaurus (for example, the word metal can have synonyms such as aluminum and steel).
SELECT * FROM
Production.ProductDescription
WHERE 
CONTAINS(Description, ' FORMSOF (INFLECTIONAL, ride) ')


SELECT * FROM
Production.ProductDescription
WHERE
CONTAINS(Description, 'ISABOUT (performance weight (1.0)
, comfortable weight (.1), smooth weight (.1) )' )


UPDATE Production.ProductDescription
SET Description = 'Superior perfomance and comfortable with smooth'
WHERE ProductDescriptionID = 613


SELECT * FROM
Production.ProductDescription
WHERE 
CONTAINS(Description, 'bike NEAR performance')


SELECT * FROM
Production.ProductDescription
WHERE 
CONTAINS(Description, ' "Mountain" OR "Road" ')
