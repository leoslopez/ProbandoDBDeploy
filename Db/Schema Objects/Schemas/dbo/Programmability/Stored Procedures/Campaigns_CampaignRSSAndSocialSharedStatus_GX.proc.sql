CREATE PROCEDURE [dbo].[Campaigns_CampaignRSSAndSocialSharedStatus_GX]
@IdCampaign int
AS
SELECT C.EnabledRSS, C.EnabledShareSocialNetwork
FROM Campaign C WITH(NOLOCK)
WHERE C.IdCampaign = @IdCampaign 