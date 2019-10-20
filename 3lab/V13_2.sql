USE AdventureWorks2012;
GO

ALTER TABLE
    dbo.Address
ADD
    CountryRegionCode NVARCHAR(3),
    TaxRate SMALLMONEY,
    DiffMin AS (TaxRate - 5.00);
GO


CREATE TABLE #Address (
    AddressID INT NOT NULL PRIMARY KEY,
    AddressLine1 NVARCHAR(60) NOT NULL,
    AddressLine2 NVARCHAR(60) NULL,
    City NVARCHAR(25) NULL,
    StateProvinceID INT NOT NULL,
    PostalCode NVARCHAR(15) NOT NULL,
    ModifiedDate DATETIME NOT NULL,
    CountryRegionCode NVARCHAR(3),
    TaxRate SMALLMONEY,
);
GO


WITH TaxRate_CTE(StateProvinceID,TaxRate) AS (
    SELECT
	StateProvinceID,
        TaxRate
    FROM
        Sales.SalesTaxRate
    WHERE
        TaxRate > 5.00
)
INSERT INTO #Address  (
        AddressID,
	AddressLine1,
	AddressLine2,
	City,
	StateProvinceID,
	PostalCode,
	ModifiedDate,
	CountryRegionCode,
	TaxRate
    )
SELECT
	a.AddressID,
	a.AddressLine1,
	a.AddressLine2,
	a.City,
	a.StateProvinceID,
	a.PostalCode,
	a.ModifiedDate,
	b.CountryRegionCode,
	d.TaxRate
FROM
    [dbo].[Address] as a
    INNER JOIN Person.StateProvince as b
        ON (a.StateProvinceID = b.StateProvinceID)
		INNER JOIN Sales.SalesTaxRate as c
			ON (b.StateProvinceID = c.StateProvinceID)
			INNER JOIN TaxRate_CTE as d
				ON (c.StateProvinceID = d.StateProvinceID)

DELETE
FROM
    #Address
WHERE
    StateProvinceID = 36;


SET IDENTITY_INSERT [dbo].[Address] ON

MERGE
    [dbo].[Address] AS target
    USING #Address AS source
ON (target.AddressID = source.AddressID)
WHEN MATCHED THEN
    UPDATE SET
        CountryRegionCode  = source.CountryRegionCode ,
        TaxRate = source.TaxRate
WHEN NOT MATCHED BY target THEN
    INSERT
    (
        AddressID,
        AddressLine1,
        AddressLine2,
        City,
        StateProvinceID,
	PostalCode,
	ModifiedDate,
	CountryRegionCode,
        TaxRate
    )
    VALUES
    (
        AddressID,
        AddressLine1,
        AddressLine2,
        City,
        StateProvinceID,
	PostalCode,
	ModifiedDate,
	CountryRegionCode,
        TaxRate
    )
WHEN NOT MATCHED BY source THEN
    DELETE;
GO


