
UPDATE [dbo].[TemplateCategory] SET [Name] = (N'Layout') WHERE [IdTemplateCategory] = 1

UPDATE [dbo].[Template] SET [IdTemplateCategory] = 1

DELETE [dbo].[TemplateCategory] WHERE  [IdTemplateCategory] != 1