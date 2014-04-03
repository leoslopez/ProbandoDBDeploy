CREATE TABLE [dbo].[ImportedBilling] (
    [IdImportedBilling] INT           IDENTITY (1, 1) NOT NULL,
    [FileName]          VARCHAR (200) NOT NULL,
    [UploadDate]        DATETIME      NOT NULL,
    [IsProcessed]       BIT           NOT NULL,
    [Name]              VARCHAR (200) NOT NULL,
    [IdAdminUploaded]   INT           NOT NULL,
    [IdAdminProcessing] INT           NULL,
    [ProcessingDate]    DATETIME      NULL
);









