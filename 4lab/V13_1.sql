USE AdventureWorks2012;
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
           WHERE TABLE_SCHEMA=N'Production' AND TABLE_NAME = N'WorkOrderHst')
BEGIN
  DROP TABLE Production.WorkOrderHst
END

CREATE TABLE Production.WorkOrderHst (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	[Action] NVARCHAR(6) NOT NULL,
	ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
	SourceID INT NOT NULL,
	UserName  NVARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);
GO

IF OBJECT_ID ('Production.WorkOrder_ChangeTracking', 'TR') IS NOT NULL
	DROP TRIGGER Production.WorkOrder_ChangeTracking;
GO

CREATE TRIGGER Production.WorkOrder_ChangeTracking
	ON Production.WorkOrder
	AFTER INSERT, UPDATE, DELETE
	AS BEGIN

	DECLARE @event_type varchar(6), @sourceID int,  @date date, @user nvarchar(256);

	SET @event_type = 'nothing';
	SET @sourceID = -1;

	SET @event_type = (
		CASE 
			WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM  deleted) THEN 'update'
			WHEN EXISTS(SELECT * FROM inserted) THEN 'insert'
			WHEN EXISTS(SELECT * FROM deleted) THEN 'delete'
		END
	)
	SET @user = SUSER_NAME();
	IF (@event_type = 'delete') 
		INSERT INTO Production.WorkOrderHst ([Action], ModifiedDate, SourceID, UserName)
		SELECT @event_type, GETDATE(), WorkOrderID, @user FROM deleted
	ELSE 
		INSERT INTO Production.WorkOrderHst ([Action], ModifiedDate, SourceID, UserName)
		SELECT @event_type, GETDATE(), WorkOrderID, @user FROM inserted
END
GO

INSERT INTO Production.WorkOrder (ProductID, OrderQty,ScrappedQty, StartDate, EndDate, DueDate,ModifiedDate) 
	VALUES (722,8, 0, GETDATE(),GETDATE(),GETDATE(),GETDATE()), (725,8, 0, GETDATE(),GETDATE(),GETDATE(),GETDATE())
GO

UPDATE Production.WorkOrder SET DueDate = GETDATE() WHERE WorkOrderID = 5;
GO

DELETE FROM Production.WorkOrder WHERE WorkOrderID = 5;
GO

SELECT * FROM Production.WorkOrderHst;
GO

CREATE VIEW Production.WorkOrderVIEW AS 
SELECT *
FROM Production.WorkOrder
GO

INSERT INTO Production.WorkOrderVIEW (ProductID,  OrderQty,ScrappedQty, StartDate, EndDate, DueDate,ModifiedDate) 
	VALUES (722,8, 0, GETDATE(),GETDATE(),GETDATE(),GETDATE()), (725,8, 0, GETDATE(),GETDATE(),GETDATE(),GETDATE())

UPDATE Production.WorkOrderVIEW SET DueDate = GETDATE() WHERE WorkOrderID = 4;
GO

DELETE FROM Production.WorkOrderVIEW WHERE WorkOrderID = 4;
GO

SELECT * FROM Production.WorkOrderHst;
GO

SELECT * FROM Production.WorkOrderVIEW

DROP VIEW Production.WorkOrderVIEW;