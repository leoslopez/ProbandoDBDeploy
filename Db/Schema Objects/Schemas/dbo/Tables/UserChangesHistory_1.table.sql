CREATE TABLE [dbo].[UserChangesHistory] (
    [IdUserChangesHistory] INT            IDENTITY (1, 1) NOT NULL,
    [Date]                 DATETIME       NOT NULL,
    [Section]              NVARCHAR (50)  NOT NULL,
    [Field]                NVARCHAR (50)  NOT NULL,
    [Old]                  NVARCHAR (MAX) NULL,
    [New]                  NVARCHAR (MAX) NULL,
    [IdAdmin]              INT            NOT NULL,
    [IdUser]               INT            NOT NULL
);









