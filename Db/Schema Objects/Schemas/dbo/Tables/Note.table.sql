CREATE TABLE [dbo].[Note] (
    [IdNote]      INT            IDENTITY (1, 1) NOT NULL,
    [Description] NVARCHAR (MAX) NOT NULL,
    [IdAdmin]     INT            NOT NULL,
    [Date]        DATETIME       NOT NULL,
    [IdUser]      INT            NOT NULL
);

