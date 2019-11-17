USE AdventureWorks2012;
GO

CREATE FUNCTION
    dbo.GetSumOrder (@PurchaseOrderID INT)
RETURNS
    Money
AS
BEGIN
    DECLARE @Sum Money

    SELECT @Sum = a.LineTotal 
    FROM Purchasing.PurchaseOrderDetail as a
	where a.PurchaseOrderID = @PurchaseOrderID

    RETURN @Sum
END;
GO

SELECT dbo.GetSumOrder(1)
GO

CREATE FUNCTION
    dbo.FN_GetOrders (@CustomerID INT, @NumberOfString INT)
RETURNS
    TABLE
AS
RETURN
(
    SELECT
		*
    FROM
        Sales.SalesOrderHeader as a
	WHERE a.CustomerID = @CustomerID
	ORDER BY a.TotalDue DESC
    OFFSET 0 ROWS
    FETCH NEXT @NumberOfString ROWS ONLY
);
GO

SELECT
    *
FROM
    Sales.SalesOrderHeader as a
    CROSS APPLY dbo.FN_GetOrders (a.CustomerID, 3);
GO

SELECT
    *
FROM
    Sales.SalesOrderHeader as b
    OUTER APPLY dbo.FN_GetOrders (b.CustomerID, 3);
GO

DROP FUNCTION
    dbo.FN_GetOrders;
GO

CREATE FUNCTION
    dbo.FN_GetOrders (@CustomerID INT, @NumberOfString INT)
RETURNS
    @GetOrders TABLE
    (
        SalesOrderID INT NOT NULL,
	RevisionNumber TINYINT NOT NULL,
	OrderDate DATETIME NOT NULL,
	DueDate DATETIME NOT NULL,
	ShipDate DATETIME NULL,
	[Status] TINYINT NOT NULL,
	OnlineOrderFlag dbo.Flag NOT NULL,
	SalesOrderNumber NVARCHAR(23),
	PurchaseOrderNumber dbo.OrderNumber NULL,
	AccountNumber dbo.AccountNumber NULL,
	CustomerID INT NOT NULL,
	SalesPersonID INT NULL,
	TerritoryID INT NULL,
	BillToAddressID INT NOT NULL,
	ShipToAddressID INT NOT NULL,
	ShipMethodID INT NOT NULL,
	CreditCardID INT NULL,
	CreditCardApprovalCode VARCHAR(15) NULL,
	CurrencyRateID INT NULL,
	SubTotal MONEY NOT NULL ,
	TaxAmt MONEY NOT NULL,
	Freight MONEY NOT NULL,
	TotalDue INT NOT NULL,
	Comment NVARCHAR(128) NULL,
	rowguid UNIQUEIDENTIFIER ROWGUIDCOL  NOT NULL,
	ModifiedDate DATETIME NOT NULL
    )
AS
BEGIN
    INSERT INTO
        @GetOrders
        (
            SalesOrderID,
	    RevisionNumber,
	    OrderDate,
	    DueDate,
	    ShipDate,
	    [Status],
	    OnlineOrderFlag,
	    SalesOrderNumber,
	    PurchaseOrderNumber,
	    AccountNumber,
	    CustomerID,
	    SalesPersonID,
	    TerritoryID,
	    BillToAddressID,
	    ShipToAddressID,
	    ShipMethodID,
	    CreditCardID,
	    CreditCardApprovalCode,
	    CurrencyRateID,
            SubTotal,
	    TaxAmt,
	    Freight,
            TotalDue,
	    Comment,
	    rowguid,
	    ModifiedDate
        )
    SELECT
	SalesOrderID,
	RevisionNumber,
	OrderDate,
	DueDate,
	ShipDate,
	[Status],
	OnlineOrderFlag,
	SalesOrderNumber,
	PurchaseOrderNumber,
	AccountNumber,
	CustomerID,
	SalesPersonID,
	TerritoryID,
	BillToAddressID,
	ShipToAddressID,
	ShipMethodID,
	CreditCardID,
	CreditCardApprovalCode,
	CurrencyRateID,
	SubTotal,
	TaxAmt,
	Freight,
	TotalDue,
	Comment,
	rowguid,
	ModifiedDate
    FROM
	Sales.SalesOrderHeader as a
    WHERE
        a.CustomerID = @CustomerID
    ORDER BY a.TotalDue DESC
    OFFSET 0 ROWS
    FETCH NEXT @NumberOfString ROWS ONLY;
    RETURN
END;
GO
