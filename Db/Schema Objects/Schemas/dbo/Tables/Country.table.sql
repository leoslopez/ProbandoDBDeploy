CREATE TABLE [dbo].[Country] (
    [IdCountry]      INT            IDENTITY (1, 1) NOT NULL,
    [Name]           NVARCHAR (255) NOT NULL,
    [Code]           NVARCHAR (255) NULL,
    [AlternateNames] NVARCHAR (255) NULL,
    [Order]          SMALLINT       NULL,
	[DialingCode]	 INT			NULL
);





