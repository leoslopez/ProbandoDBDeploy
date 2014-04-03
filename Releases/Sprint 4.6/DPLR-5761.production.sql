-- =============================================
-- Script Template
-- =============================================

CREATE TABLE [dbo].[Resource]
(
	[IdResource] int IDENTITY (1, 1) NOT NULL,
	[DescriptionEs] nvarchar(MAX) NULL,
	[DescriptionEn] nvarchar(MAX) NULL,
)

GO

ALTER TABLE [dbo].[Resource]
    ADD CONSTRAINT [PK_Resource] PRIMARY KEY CLUSTERED ([IdResource] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

GO

ALTER TABLE [dbo].[TemplateCategory] ADD [IdResource] int NULL

GO

ALTER TABLE [dbo].[TemplateCategory]
    ADD CONSTRAINT [FK_TemplateCategory_Resource] FOREIGN KEY ([IdResource]) REFERENCES [dbo].[Resource] ([IdResource]) ON DELETE NO ACTION ON UPDATE NO ACTION;

GO

	SET IDENTITY_INSERT [dbo].[Resource] ON

	INSERT [dbo].[Resource] ([IdResource], [DescriptionEs],[DescriptionEn]) 
							  VALUES (1,N'Plantillas', N'Layouts');

	INSERT [dbo].[Resource] ([IdResource], [DescriptionEs],[DescriptionEn]) 
							  VALUES (2,N'Fechas Especiales', N'Holidays');

	INSERT [dbo].[Resource] ([IdResource], [DescriptionEs],[DescriptionEn]) 
							  VALUES (3,N'Industrias', N'Industries');

	INSERT [dbo].[Resource] ([IdResource], [DescriptionEs],[DescriptionEn]) 
							  VALUES (4,N'Promociones', N'Promotions');

	INSERT [dbo].[Resource] ([IdResource], [DescriptionEs],[DescriptionEn]) 
							  VALUES (5,N'Saludos', N'Greetings');

	INSERT [dbo].[Resource] ([IdResource], [DescriptionEs],[DescriptionEn]) 
							  VALUES (6,N'eCommerce', N'eCommerce');

	INSERT [dbo].[Resource] ([IdResource], [DescriptionEs],[DescriptionEn]) 
							  VALUES (7,'Newsletter', N'Newsletter');

	SET IDENTITY_INSERT [dbo].[Resource] OFF

GO

UPDATE [dbo].[Template] SET [IdTemplateCategory] = 2 WHERE [IdTemplateCategory] = 3

UPDATE [dbo].[TemplateCategory] SET [IdResource] = 1, [Name] = N'Layouts' WHERE [IdtemplateCategory] = 1;
UPDATE [dbo].[TemplateCategory] SET [IdResource] = 2, [Name] = N'Holidays' WHERE [IdtemplateCategory] = 2
UPDATE [dbo].[TemplateCategory] SET [IdResource] = 3, [Name] = N'Industries' WHERE [IdtemplateCategory] = 3

SET IDENTITY_INSERT [dbo].[TemplateCategory] ON		
		INSERT [dbo].[TemplateCategory] ([IdTemplateCategory], [Name], [Active], [IdResource]) VALUES (4, N'Promotions', 1, 4)	
		INSERT [dbo].[TemplateCategory] ([IdTemplateCategory], [Name], [Active], [IdResource]) VALUES (5, N'Greetings', 1, 5)	
		INSERT [dbo].[TemplateCategory] ([IdTemplateCategory], [Name], [Active], [IdResource]) VALUES (6, N'eCommerce', 1, 6)	
		INSERT [dbo].[TemplateCategory] ([IdTemplateCategory], [Name], [Active], [IdResource]) VALUES (7, N'Newsletter', 1, 7)	
SET IDENTITY_INSERT [dbo].[TemplateCategory] OFF
	



