USE AdventureWorks2012;
GO

ALTER TABLE [dbo].[Address]
  ADD AddressType NVARCHAR(50);
GO

DECLARE @AddressVar TABLE
(
    AddressID INT NOT NULL,
    AddressLine1 NVARCHAR(60) NOT NULL,
    AddressLine2 NVARCHAR(60) NULL,
    City NVARCHAR(30) NULL,
    StateProvinceID INT NOT NULL,
    PostalCode NVARCHAR(15) NOT NULL,
    ModifiedDate DATETIME NOT NULL,
    AddressType NVARCHAR(50)
);
INSERT INTO
    @AddressVar
    (
	AddressID,
	AddressLine1,
	AddressLine2,
	City,
	StateProvinceID,
	PostalCode,
	ModifiedDate,
	AddressType
    )
SELECT
	a.AddressID,
	a.AddressLine1,
	a.AddressLine2,
	a.City,
	a.StateProvinceID,
	a.PostalCode,
	a.ModifiedDate,
	b.Name
FROM
    [dbo].[Address] as a
	LEFT JOIN Person.BusinessEntityAddress
        ON (a.[AddressID] = [Person].[BusinessEntityAddress].[AddressID])
	    LEFT JOIN Person.AddressType as b
            ON (Person.BusinessEntityAddress.AddressTypeID = b.AddressTypeID)

UPDATE
    [dbo].[Address]
SET
    [dbo].[Address].AddressType = AddressVar.AddressType,
	[dbo].[Address].AddressLine2 = iif([dbo].[Address].AddressLine2 is null, [dbo].[Address].AddressLine1, [dbo].[Address].AddressLine2)
FROM
    [dbo].[Address]
    INNER JOIN @AddressVar AS AddressVar
        ON ([dbo].[Address].AddressID = AddressVar.AddressID);
GO


DELETE
    Address
FROM
    [dbo].[Address] Address, [dbo].[Address] Address1
WHERE
    Address.AddressID < Address1.AddressID AND Address.AddressType = Address1.AddressType 
GO


ALTER TABLE
    [dbo].[Address]
DROP COLUMN
    AddressType;
ALTER TABLE
    [dbo].[Address]
DROP CONSTRAINT
    AK_Address_PostalCode,
    DF_Address_ModifiedDate
GO


DROP TABLE
    [dbo].[Address]
GO





