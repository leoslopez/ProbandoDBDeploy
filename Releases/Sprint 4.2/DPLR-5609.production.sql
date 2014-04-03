--Backup templates on temp table
/*
--Not part of the story see comment --http://jira.makingsense.com/browse/DPLR-5609#comment-46401
PRINT 'Backup years from templates'

IF NOT EXISTS (SELECT * FROM SYSOBJECTS WHERE NAME="TemplateTemp" AND XTYPE= 'U')
CREATE TABLE TemplateTemp(
	[IdTemplate] [int] NOT NULL,
	[HtmlCode] [varchar](max) NOT NULL)
GO
DELETE FROM TemplateTemp
GO
INSERT INTO TemplateTemp (IdTemplate,HtmlCode) 
SELECT IdTemplate,HtmlCode
FROM dbo.Template 
WHERE IsCreatedByNewEditor = 1 AND IdUser is NULL 
GO
UPDATE [dbo].[Template]
SET [HtmlCode] = REPLACE(REPLACE([HtmlCode], '2014', '2015'), '2013', '2014')
WHERE IsCreatedByNewEditor = 1 AND IdUser is NULL 
GO*/