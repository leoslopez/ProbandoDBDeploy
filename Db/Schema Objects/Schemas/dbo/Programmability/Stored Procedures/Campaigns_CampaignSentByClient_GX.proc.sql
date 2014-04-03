CREATE PROCEDURE [dbo].[Campaigns_CampaignSentByClient_GX]
@IdUser INT
AS
SELECT ISNULL(count(IdCampaign),0)
FROM Campaign WITH(NOLOCK)
WHERE IdUser = @IdUser
AND Active = 1
AND [Status] in (5,6,9)
AND ( TestABCategory = 3 OR TestABCategory IS NULL )