CREATE TABLE [dbo].[ImportTask] (
    [IdImportTask]     INT           IDENTITY (1, 1) NOT NULL,
    [StartDate]        DATETIME      NOT NULL,
    [Server]           VARCHAR (200) NULL,
    [Status]           SMALLINT      NOT NULL,
    [IdImportRequest]  INT           NULL,
    [IdImportResult]   INT           NULL,
    [FinishDate]       DATETIME      NULL,
    [NumberOfAttempts] INT           DEFAULT ((0)) NOT NULL,
    [AmountImported]   INT           DEFAULT ((0)) NOT NULL,
    [DateLastImported] DATETIME      NULL
);









