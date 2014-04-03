CREATE TABLE [dbo].[MessageTemplate] (
    [IdMessageTemplate] INT          IDENTITY (1, 1) NOT NULL,
    [Name]              VARCHAR (50) NOT NULL,
    [Text]              TEXT         NOT NULL,
    [Type]              VARCHAR (50) NULL,
    [ParentTemplate]    INT          NULL
);



