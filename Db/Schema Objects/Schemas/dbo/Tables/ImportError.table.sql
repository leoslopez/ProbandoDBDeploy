CREATE TABLE [dbo].[ImportError] (
    [IdImportError]  INT           IDENTITY (1, 1) NOT NULL,
    [IdImportResult] INT           NOT NULL,
    [ErrorCode]      VARCHAR (50)  NOT NULL,
    [LineNumber]     INT           NOT NULL,
    [Email]          VARCHAR (400) NULL
);





