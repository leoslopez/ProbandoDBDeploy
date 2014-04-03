CREATE TABLE [dbo].[FieldXForm] (
    [IdField]            INT           NOT NULL,
    [IdForm]             INT           NOT NULL,
    [Label]              NVARCHAR (50) NOT NULL,
    [SampleValue]        NVARCHAR (50) NOT NULL,
    [NumberOfCharacters] INT           NOT NULL,
    [IsRequired]         BIT           NOT NULL,
    [FormPosition]       INT           NULL,
    [IsMultiline]        BIT           NOT NULL
) ON [Field]