CREATE TABLE [dbo].[City] (
    [IdCity]  INT           IDENTITY (1, 1) NOT NULL,
    [IdState] INT           NOT NULL,
    [Name]    NVARCHAR (50) NOT NULL,
    [ZipCode] NVARCHAR (50) NULL
);



