USE AdventureWorks2012;
GO

CREATE VIEW Production.WorkOrderScrapReasonVIEW
WITH ENCRYPTION, SCHEMABINDING
AS
SELECT 
    WO.WorkOrderID,
    WO.ProductID,
    WO.OrderQty,
    WO.StockedQty,
    WO.ScrappedQty,
    WO.StartDate,
    WO.EndDate,
    WO.DueDate,
    SR.ScrapReasonID,
    WO.ModifiedDate AS WorkOrderMD,
    P.Name AS ProductName,
    SR.Name AS ScrapReasonName,
    SR.ModifiedDate AS ScrapReasonMD
FROM Production.WorkOrder AS WO
JOIN Production.ScrapReason AS SR
ON WO.ScrapReasonID = SR.ScrapReasonID
JOIN Production.Product AS P
ON P.ProductID = WO.ProductID
GO
SELECT OBJECT_DEFINITION (OBJECT_ID('Production.WorkOrderScrapReasonVIEW')) AS ObjectDefinition; 
GO 

CREATE UNIQUE CLUSTERED INDEX ProductionWorkOrderScrapReasonVIEW_Index   
    ON Production.WorkOrderScrapReasonVIEW (WorkOrderID); 
GO

CREATE TRIGGER Production.WorkOrderScrapReasonVIEW_Insert
ON Production.WorkOrderScrapReasonVIEW
INSTEAD OF INSERT
AS
	DECLARE @ID_table TABLE (ScrapReasonID INT, Name NVARCHAR(100));
	DECLARE @ProductID INT;

	SELECT @ProductID = Production.Product.ProductID
	FROM Production.Product
	JOIN inserted
	ON inserted.ProductName = Production.Product.Name

	INSERT INTO Production.ScrapReason(
		Name,
		ModifiedDate
	) 
	OUTPUT inserted.ScrapReasonID, inserted.Name INTO @ID_table
	SELECT 
		ScrapReasonName,
		ScrapReasonMD
	FROM inserted;


	INSERT INTO Production.WorkOrder(
		 ProductID,
		 OrderQty,
		 ScrappedQty,
		 StartDate,
		 EndDate,
		 DueDate,
		 ScrapReasonID,
		 ModifiedDate
	) 
	SELECT
		 @ProductID,
		 OrderQty,
		 ScrappedQty,
		 StartDate,
		 EndDate,
		 DueDate,
		 tab.ScrapReasonID,
		 WorkOrderMD
	FROM inserted
	JOIN @ID_table tab
	ON tab.Name = inserted.ScrapReasonName;
GO

SET IDENTITY_INSERT Production.WorkOrder OFF
SET IDENTITY_INSERT Production.ScrapReason OFF
GO

CREATE TRIGGER Production.WorkOrderScrapReasonVIEW_Update
ON Production.WorkOrderScrapReasonVIEW
INSTEAD OF UPDATE
AS
	DECLARE @ProductID INT;

	SELECT @ProductID = Production.Product.ProductID
	FROM Production.Product
	JOIN inserted
	ON inserted.ProductName = Production.Product.Name

	UPDATE Production.ScrapReason
	SET 
		Name = inserted.ScrapReasonName,
		ModifiedDate = inserted.ScrapReasonMD
	FROM inserted
	WHERE inserted.ScrapReasonID = Production.ScrapReason.ScrapReasonID;

	UPDATE Production.WorkOrder
	SET 
		 ScrappedQty=inserted.ScrappedQty,
		 StartDate=inserted.StartDate,
		 EndDate=inserted.EndDate,
		 DueDate=inserted.DueDate,
		 ScrapReasonID=inserted.ScrapReasonID,
		 ModifiedDate=inserted.WorkOrderMD
	FROM inserted
	WHERE inserted.WorkOrderID = Production.WorkOrder.WorkOrderID AND Production.WorkOrder.ProductID = @ProductID;
GO

CREATE TRIGGER Production.WorkOrderScrapReasonVIEW_Delete
ON Production.WorkOrderScrapReasonVIEW
INSTEAD OF DELETE
AS
	DECLARE @ProductID INT;

	SELECT @ProductID = Production.Product.ProductID
	FROM Production.Product
	JOIN deleted
	ON deleted.ProductName = Production.Product.Name

	
	DELETE WO FROM Production.WorkOrder WO
	JOIN deleted
	ON WO.ScrapReasonID = deleted.ScrapReasonID
	WHERE WO.ProductID = @ProductID;

	DELETE SR FROM Production.ScrapReason SR
	JOIN deleted
	ON deleted.ScrapReasonID = SR.ScrapReasonID
GO


INSERT INTO Production.WorkOrderScrapReasonVIEW (
	ProductName,  
	OrderQty,
	ScrappedQty, 
	StartDate, 
	EndDate,
	DueDate,
	WorkOrderMD,
	ScrapReasonName,
	ScrapReasonMD
) 
VALUES ( 'Blade',555, 0, GETDATE(),GETDATE(),GETDATE(), GETDATE(),  'kCk', GETDATE())


SELECT * FROM Production.WorkOrderScrapReasonVIEW 
INNER JOIN 
	(
		SELECT 
		MAX(Production.ScrapReason.ScrapReasonID) AS MaxScrapReasonID 
		FROM Production.ScrapReason
	) AS groupedtt
ON Production.WorkOrderScrapReasonVIEW.ScrapReasonID = groupedtt.MaxScrapReasonID
GO
	


UPDATE Production.WorkOrderScrapReasonVIEW SET
	ScrappedQty=10, 
	StartDate= GETDATE(), 
	EndDate= GETDATE()+1,
	DueDate= GETDATE(),
	WorkOrderMD= GETDATE(),
	ScrapReasonName= 'KKl',
	ScrapReasonMD= GETDATE()
	WHERE ProductName = 'Blade' AND WorkOrderID=(
	SELECT x.MaxID
    FROM (
		SELECT MAX(t.WorkOrderID) AS MaxID
        FROM Production.WorkOrder AS t
		) AS
	x)
;
GO

SELECT * FROM Production.WorkOrderScrapReasonVIEW 
INNER JOIN 
	(
		SELECT 
		MAX(Production.ScrapReason.ScrapReasonID) AS MaxScrapReasonID 
		FROM Production.ScrapReason
	) AS groupedtt
ON Production.WorkOrderScrapReasonVIEW.ScrapReasonID = groupedtt.MaxScrapReasonID
GO

DECLARE @maxId INT;
SET @maxId =  (
	SELECT x.MaxScrapReasonID
    FROM (
		SELECT MAX(t.ScrapReasonID) AS MaxScrapReasonID
        FROM Production.ScrapReason AS t
		) AS
	x);

DELETE FROM Production.WorkOrderScrapReasonVIEW
 WHERE ProductName = 'Blade' AND ScrapReasonID = @maxId

SELECT * FROM Production.WorkOrderScrapReasonVIEW  WHERE ScrapReasonID = @maxId
GO

DROP VIEW Production.WorkOrderScrapReasonVIEW;