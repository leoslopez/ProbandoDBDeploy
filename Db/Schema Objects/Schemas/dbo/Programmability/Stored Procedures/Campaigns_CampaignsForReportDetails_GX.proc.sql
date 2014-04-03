
CREATE PROCEDURE [dbo].[Campaigns_CampaignsForReportDetails_GX] @IdCampaign INT, 
                                                               @Status     INT 
AS 
    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   GetTestABSet(@IdCampaign); 

    SELECT result.Name, 
           MAX(result.Subject)                 Subject, 
           result.ContentType, 
           SUM(result.DistinctOpenedMailCount) DistinctOpenedMailCount, 
           SUM(result.SoftBouncedMailCount)    SoftBouncedMailCount, 
           SUM(result.HardBouncedMailCount)    HardBouncedMailCount, 
           SUM(result.UnopenedMailCount)       UnopenedMailCount, 
           MIN(result.UTCSentDate)             UTCSentDate, 
           result.CampaignType, 
           result.IsTestAB, 
           result.SamplingPercentage, 
           result.TestABType 
    FROM   (SELECT C.Name, 
                   C.[Subject], 
                   C.ContentType, 
                   t.DistinctOpenedMailCount, 
                   t.SoftBouncedMailCount, 
                   t.HardBouncedMailCount, 
                   t.UnopenedMailCount, 
                   C.UTCSentDate, 
                   C.CampaignType, 
                   CAST(ISNULL(C.IdTestAB, 0) as BIT) as IsTestAB, 
                   ISNULL(Test.SamplingPercentage, 0) as SamplingPercentage, 
                   ISNULL(Test.TestType, 0)           as TestABType 
            FROM   @t t1 
                   JOIN Campaign C 
                     ON T1.IdCampaign = C.IdCampaign 
                   LEFT JOIN(SELECT c.IdCampaign, 
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
                                    COUNT(CASE IdDeliveryStatus 
                                            WHEN 100 THEN [COUNT] 
                                          END) DistinctOpenedMailCount 
                             FROM   CampaignDeliveriesOpenInfo c WITH(NOLOCK) 
                             GROUP  BY c.IdCampaign)t 
                          ON t1.IdCampaign = t.IdCampaign 
                   LEFT JOIN TestAB Test 
                          ON Test.IdTestAB = C.IdTestAB) as result 
    GROUP  BY result.Name, 
              result.ContentType, 
              result.CampaignType, 
              result.IsTestAB, 
              result.SamplingPercentage, 
              result.TestABType 