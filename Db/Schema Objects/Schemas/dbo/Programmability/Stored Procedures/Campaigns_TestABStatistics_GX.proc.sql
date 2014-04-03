CREATE PROCEDURE [dbo].[Campaigns_TestABStatistics_GX]
@IdCampaign INT
AS
SET NOCOUNT ON 

DECLARE @t TABLE 
( IdCampaign INT PRIMARY KEY ); 

INSERT INTO @t 
SELECT IdCampaign 
FROM   GetTestABSet(@IdCampaign) 

SELECT  C.IdCampaign, C.[Name], c.UTCSentDate, C.[Subject], 
[dbo].[CampaignTypeToInt](c.CampaignType, ContentType) as Type, 
CS.DistinctOpenedMailCount, CS.HardBouncedMailCount, CS.SoftBouncedMailCount, 
CS.UnopenedMailCount, C.Status, C.EnabledShareSocialNetwork, C.CampaignType, 
CS.DistinctClickedMailCount, CS.TotalClickedMailCount, CS.TotalOpenedMailCount, 
CS.LastClickedEmailDate, CS.LastOpenedEmailDate, CS.IsWinner  
FROM @t t
JOIN Campaign C WITH(NOLOCK)
ON t.IdCampaign=c.IdCampaign 
LEFT JOIN CampaignStatistic CS WITH(NOLOCK)
ON CS.IdCampaign = C.IdCampaign
WHERE C.IdCampaign != @IdCampaign