CREATE TABLE [dbo].[Footer] (
    [IdFooter] INT            IDENTITY (300, 1) NOT NULL,
    [Text]     NVARCHAR (MAX) NULL,
    [Active]   BIT            NOT NULL,
    [IdUser]   INT            NOT NULL
);

