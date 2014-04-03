CREATE TABLE [dbo].[FieldMapping] (
    [IdFieldMapping]  INT           IDENTITY (1, 1) NOT NULL,
    [IdImportRequest] INT           NOT NULL,
    [IdField]         INT           NOT NULL,
    [ColumnPosition]  INT           NOT NULL,
    [ColumnName]      NVARCHAR (50) NOT NULL,
    [BlankFields]     BIT           NOT NULL,
    [DateFormat]      NVARCHAR (50) NULL
) ON [Field]