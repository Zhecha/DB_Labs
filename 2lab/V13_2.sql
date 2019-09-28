use [AdventureWorks2012]
GO;

create table [dbo].[Address] (
	[AddressID] INT NOT NULL,
	[AddressLine1] NVARCHAR(60) NOT NULL,
	[AddressLine2] NVARCHAR(60) NULL,
	[City] NVARCHAR(30) NOT NULL,
	[StateProvinceID] INT IDENTITY(1,1) NOT NULL,
	[PostalCode] NVARCHAR(15) NOT NULL,
	[ModifiedDate] DATETIME NOT NULL,
	CONSTRAINT [PK_Address_AddressID] PRIMARY KEY CLUSTERED ([AddressID] ASC),
);
GO

alter table [dbo].[Address] drop constraint [PK_Address_AddressID];
alter table [dbo].[Address] add PRIMARY KEY CLUSTERED([StateProvinceID] ASC, [PostalCode]);
GO

alter table [dbo].[Address]
	add constraint AK_Address_PostalCode check([PostalCode] not like '[A-Za-z]%');
GO

alter table [dbo].[Address] 
 add constraint DF_Address_ModifiedDate 
 default getutcdate() for [ModifiedDate];
GO


insert into [dbo].[Address] (
	[AddressID],
	[AddressLine1],
	[AddressLine2],
	[City],
	[PostalCode],
	[ModifiedDate]
)
 select 
	a.[AddressID],
	a.[AddressLine1],
	a.[AddressLine2],
	a.[City],
	a.[PostalCode],
	a.[ModifiedDate]
from 
	(([Person].[Address] as a
		inner join
			[Person].[StateProvince]  on [Person].[StateProvince].[CountryRegionCode] = 'US' )
	inner join 
			(select b.[StateProvinceID], b.[PostalCode], max(b.[AddressID]) as maxId 
				from [Person].[Address] as b group by b.[StateProvinceID], b.[PostalCode]) groupMaxId
	on a.[StateProvinceID] = groupMaxId.[StateProvinceID] and a.[PostalCode] = groupMaxId.[PostalCode] and a.[AddressID] = groupMaxId.[maxId])
where 
	a.[PostalCode] not like '[A-Za-z]%'
go


alter table [dbo].[Address]
	alter column [City] NVARCHAR(25);
GO

