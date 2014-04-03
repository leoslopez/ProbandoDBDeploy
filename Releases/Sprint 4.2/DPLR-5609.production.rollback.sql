/*
Not part of the story see comment --http://jira.makingsense.com/browse/DPLR-5609#comment-46401
UPDATE dbo.Template 
SET HtmlCode = copy.HtmlCode
FROM dbo.Template t
inner join dbo.TemplateTemp copy
on t.IdTemplate = copy.IdTemplate
*/
