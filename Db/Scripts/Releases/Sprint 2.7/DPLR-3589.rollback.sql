USE [Doppler2011_Local]
GO
/****** Object:  StoredProcedure [dbo].[Campaigns_CampaignSentCampaignByID_GX]    Script Date: 04/30/2013 12:01:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[Campaigns_CampaignSentCampaignByID_GX]
@IdCampaign INT
AS
SELECT C.IdCampaign,
C.[Name],
c.UTCSentDate,
C.[Subject], 
[dbo].[CampaignTypeToInt](c.CampaignType, ContentType) AS CampaignTypeInt,
ISNULL(DistinctOpenedMailCount,0) AS DistinctOpenedMailCount,
ISNULL(HardBouncedMailCount,0) AS HardBouncedMailCount,
ISNULL(SoftBouncedMailCount,0) AS SoftBouncedMailCount,
ISNULL(UnopenedMailCount,0)AS UnopenedMailCount,
C.Status,
C.EnabledShareSocialNetwork,
C.CampaignType, CAST(ISNULL(C.IdTestAB, 0) as BIT) as IsTestAB,
ISNULL(T.SamplingPercentage,0) as SamplingPercentage, 
ISNULL(T.TestType,0) as TestABType
FROM dbo.Campaign c WITH(NOLOCK)
LEFT JOIN (
SELECT cdoi.IdCampaign,
COUNT(CASE IdDeliveryStatus
WHEN 0 THEN 0
END) UnopenedMailCount,
COUNT(CASE IdDeliveryStatus
WHEN 2 THEN 2
WHEN 8 THEN 2
END) HardBouncedMailCount,
COUNT(CASE IdDeliveryStatus
WHEN 1 THEN 1
WHEN 3 THEN 1
WHEN 4 THEN 1
WHEN 5 THEN 1
WHEN 6 THEN 1
WHEN 7 THEN 1
END) SoftBouncedMailCount,
SUM(CASE IdDeliveryStatus
WHEN 100 THEN 1
END) DistinctOpenedMailCount
FROM CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)
WHERE cdoi.IdCampaign = @IdCampaign
GROUP BY cdoi.IdCampaign
) OPENS
ON C.IdCampaign = OPENS.IdCampaign
LEFT JOIN TestAB T ON T.IdTestAB = C.IdTestAB
WHERE C.IdCampaign = @IdCampaign