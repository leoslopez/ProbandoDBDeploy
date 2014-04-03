CREATE TABLE [dbo].[Template] (
    [IdTemplate]           INT           IDENTITY (2000, 1) NOT NULL,
    [Name]                 NVARCHAR (50) NOT NULL,
    [IdUser]               INT           NULL,
    [Active]               BIT           NOT NULL,
    [HtmlCode]             VARCHAR (MAX) NOT NULL,
    [CreatedBy]            VARCHAR (50)  NULL,
    [IsCreatedByNewEditor] BIT           NOT NULL,
    [IdTemplateCategory]   INT           NULL
);











