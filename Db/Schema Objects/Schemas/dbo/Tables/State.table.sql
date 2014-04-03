CREATE TABLE [dbo].[State] (
	[IdState]   INT           IDENTITY (1, 1) NOT NULL,
	[IdCountry] INT           NOT NULL,
	[Name]      NVARCHAR (255) NOT NULL,
	[AlternateNames] NVARCHAR(255) NULL,
	[CountryCode] NVARCHAR(255) NULL,
);



