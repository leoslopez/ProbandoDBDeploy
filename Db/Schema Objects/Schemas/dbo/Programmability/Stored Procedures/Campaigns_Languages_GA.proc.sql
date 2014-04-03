CREATE PROCEDURE [dbo].[Campaigns_Languages_GA]
AS
SELECT L.IdLanguage, L.Name
FROM [Language] L WITH(NOLOCK)