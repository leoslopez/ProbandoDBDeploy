CREATE TABLE [dbo].[TemplateCategory] (
    [IdTemplateCategory] INT           IDENTITY (1, 1) NOT NULL,
    [Name]               NVARCHAR (50) NOT NULL,
    [Active]             BIT           NOT NULL,
	[IdResource]         INT           NULL
);



