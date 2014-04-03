CREATE PROCEDURE [dbo].[Actions_SocialNetworks_G]
AS 
SELECT [IdSocialNetwork],[Name],[dbo].[GetSocialNetworkColor]([Name]) as SocialNetworkColor,[ShareUrlTemplate]
FROM [dbo].[SocialNetwork] WITH(NOLOCK)