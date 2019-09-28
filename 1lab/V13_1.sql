CREATE DATABASE Evgeniy_Preys;
GO

USE Evgeniy_Preys;
GO

CREATE SCHEMA sales
GO


CREATE SCHEMA persons
GO

CREATE TABLE sales.Orders (OrderNum INT NULL)
GO

BACKUP DATABASE Evgeniy_Preys TO DISK = 'D:\Учеба\лабы\7 сем\БД\Evgeniy_Preys.bak'
GO

USE [master]
GO

DROP DATABASE Evgeniy_Preys
GO

RESTORE DATABASE Evgeniy_Preys FROM DISK = 'D:\Учеба\лабы\7 сем\БД\Evgeniy_Preys.bak'
GO


