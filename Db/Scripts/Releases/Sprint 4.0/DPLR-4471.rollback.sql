UPDATE dbo.Template 
SET HtmlCode = copy.HtmlCode
FROM dbo.Template t
inner join dbo.TemplateTemp copy
on t.IdTemplate = copy.IdTemplate

--drop table TemplateTemp