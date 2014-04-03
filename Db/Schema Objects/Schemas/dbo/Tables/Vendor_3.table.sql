CREATE TABLE [dbo].[Vendor] (
    [IdVendor] INT           IDENTITY (1, 1) NOT NULL,
    [Fullname] NVARCHAR (50) NOT NULL,
	[CountryAssigned] NVARCHAR (255) NULL,
	[Email] VARCHAR (550) NULL
);

