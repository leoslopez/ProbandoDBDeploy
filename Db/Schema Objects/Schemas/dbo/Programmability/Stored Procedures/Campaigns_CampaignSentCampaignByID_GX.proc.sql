
CREATE PROCEDURE [dbo].[Campaigns_CampaignSentCampaignByID_GX] @IdCampaign INT 
AS 
    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   GetTestABSet(@IdCampaign); 

    SELECT C.IdCampaign, 
           C.[Name], 
           SENTDATE.UTCSentDate, 
           C.[Subject], 
           [dbo].[CampaignTypeToInt](c.CampaignType, ContentType) AS CampaignTypeInt, 
           ISNULL(OPENS.DistinctOpenedMailCount, 0)                     AS DistinctOpenedMailCount,
           ISNULL(OPENS.HardBouncedMailCount, 0)                        AS HardBouncedMailCount, 
           ISNULL(OPENS.SoftBouncedMailCount, 0)                        AS SoftBouncedMailCount, 
           ISNULL(OPENS.UnopenedMailCount, 0)                           AS UnopenedMailCount, 
           C.Status, 
           C.EnabledShareSocialNetwork, 
           C.CampaignType, 
           CAST(ISNULL(C.IdTestAB, 0) as BIT)                     as IsTestAB, 
           ISNULL(T.SamplingPercentage, 0)                        as SamplingPercentage, 
           ISNULL(T.TestType, 0)                                  as TestABType, 
           C.IdUser                                               as clientID 
    FROM   dbo.Campaign c WITH(NOLOCK) 
           LEFT JOIN (SELECT @IdCampaign IdCampaign, 
                             COUNT(CASE IdDeliveryStatus 
                                     WHEN 0 THEN 0 
                                   END)  UnopenedMailCount, 
                             COUNT(CASE IdDeliveryStatus 
                                     WHEN 2 THEN 2 
                                     WHEN 8 THEN 2 
                                   END)  HardBouncedMailCount, 
                             COUNT(CASE IdDeliveryStatus 
                                     WHEN 1 THEN 1 
                                     WHEN 3 THEN 1 
                                     WHEN 4 THEN 1 
                                     WHEN 5 THEN 1 
                                     WHEN 6 THEN 1 
                                     WHEN 7 THEN 1 
                                   END)  SoftBouncedMailCount, 
                             SUM(CASE IdDeliveryStatus 
                                   WHEN 100 THEN 1 
                                 END)    DistinctOpenedMailCount
                             
                      FROM   @t t 
                             JOIN CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
                               ON t.IdCampaign = cdoi.IdCampaign 
                     ) OPENS 
                  ON C.IdCampaign = OPENS.IdCampaign 
           LEFT JOIN TestAB T 
                  ON T.IdTestAB = C.IdTestAB 
           JOIN (SELECT MIN(c.UTCSentDate) UTCSentDate, @IdCampaign IdCampaign FROM @t t JOIN dbo.Campaign c on t.IdCampaign = c.IdCampaign ) SENTDATE on SENTDATE.IdCampaign = c.IdCampaign
    WHERE  C.IdCampaign = @IdCampaign
