--Backup templates on temp table
PRINT 'Backup templates'

CREATE TABLE TemplateTemp(
	[IdTemplate] [int] NOT NULL,
	[HtmlCode] [varchar](max) NOT NULL)
GO
INSERT INTO TemplateTemp (IdTemplate,HtmlCode) 
SELECT IdTemplate,HtmlCode
FROM dbo.Template 
WHERE IdTemplate in ('10000', '10001','10002','10003')

PRINT 'New Editor  --> replacing "<p by "<div'
UPDATE [dbo].[Template]
SET [HtmlCode] = REPLACE([HtmlCode], '"<p', '"<div')
WHERE IdTemplate in ('10000', '10001','10002','10003')
GO
PRINT 'New Editor  --> replacing </p>" by </div>"'
UPDATE [dbo].[Template]
SET [HtmlCode] = REPLACE([HtmlCode], '</p>"', '</div>"')
WHERE IdTemplate in ('10000', '10001','10002','10003')
GO
--Script for old editor templates, working on our templates
/*PRINT 'Old Editor --> replacing <p by <div'
UPDATE [dbo].[Template]
SET [HtmlCode] = REPLACE([HtmlCode], '<p', '<div')
WHERE IsCreatedByNewEditor = 0 AND IdUser IS NULL
GO
PRINT 'Old Editor --> replacing </p> by </div>'
UPDATE [dbo].[Template]
SET [HtmlCode] = REPLACE([HtmlCode], '</p>', '</div>')
WHERE IsCreatedByNewEditor = 0 AND IdUser IS NULL
GO*/


