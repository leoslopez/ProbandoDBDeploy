CREATE PROCEDURE [dbo].[Actions_UserMailAgentTypes_G]
AS
SELECT [IdUserMailAgentType],[Description]
FROM [dbo].[UserMailAgentTypes] WITH(NOLOCK)