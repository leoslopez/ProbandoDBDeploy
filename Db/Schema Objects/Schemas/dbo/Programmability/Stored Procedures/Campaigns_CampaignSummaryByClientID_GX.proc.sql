CREATE PROCEDURE [dbo].[Campaigns_CampaignSummaryByClientID_GX] @IdUser     int, 
                                                                @IdCampaign int 
AS 
    DECLARE @CampaignStatus int 

    IF EXISTS(SELECT IdCampaign 
              FROM   Campaign c 
              WHERE  IdCampaign = @IdCampaign 
                     AND c.Status IN ( 4, 7, 8 ) 
                      OR c.Status IS NULL) 
      BEGIN 
          SELECT c.IdCampaign, 
                 c.Name      AS 'Name Campaign', 
                 GETDATE(), 
                 c.[Subject] AS 'Subject Campaign', 
                 c.ContentType, 
                 0, 
                 0, 
                 0, 
                 0, 
                 c.Status, 
                 0, 
                 0, 
                 0, 
                 1, 
                 c.RSSContent, 
                 c.FromName, 
                 c.FromEmail 
          FROM   dbo.Campaign c WITH(NOLOCK) 
          WHERE  c.IdCampaign = @IdCampaign 
      END 
    ELSE 
      BEGIN 
          SELECT c.IdCampaign, 
                 c.Name        AS 'Name Campaign', 
                 c.UTCSentDate AS SentDate, 
                 c.[Subject]   AS 'Subject Campaign', 
                 c.ContentType, 
                 OPENS.DistinctOpenedMailCount, 
                 OPENS.HardBouncedMailCount, 
                 OPENS.SoftBouncedMailCount, 
                 OPENS.UnopenedMailCount, 
                 c.Status, 
                 t1.TotalClickedMailCount, 
                 ISNULL(t5.UniqueShareCount, 0), 
                 ISNULL(t5.TopUniqueShareCount, 0), 
                 ISNULL(t5.IdSocialNetwork, 1), 
                 c.RSSContent, 
                 c.FromName, 
                 c.FromEmail 
          FROM   dbo.Campaign c WITH(NOLOCK) 
                 JOIN (SELECT CDOI.IdCampaign, 
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
                                    WHEN 100 THEN ISNULL(Count, 1) 
                                  END)   TotalOpenedMailCount, 
                              COUNT(CASE IdDeliveryStatus 
                                      WHEN 100 THEN 1 
                                    END) DistinctOpenedMailCount, 
                              MAX(Date)  LastOpenedEmailDate 
                       FROM   dbo.CampaignDeliveriesOpenInfo CDOI WITH(NOLOCK) 
                       WHERE  CDOI.IdCampaign = @IdCampaign 
                       GROUP  BY CDOI.IdCampaign) OPENS 
                   ON c.IdCampaign = OPENS.IdCampaign 
                 LEFT JOIN (SELECT IdCampaign, 
                                   SUM(ISNULL(Count, 1)) AS TotalClickedMailCount 
                            FROM   dbo.LinkTracking LT WITH(NOLOCK) 
                                   JOIN dbo.Link L WITH(NOLOCK) 
                                     ON LT.IdLink = L.IdLink 
                            WHERE  ( L.IdCampaign = @IdCampaign 
                                      OR L.IdCampaign IS NULL ) 
                            GROUP  BY IdCampaign)t1 
                        ON c.IdCampaign = t1.IdCampaign 
                 LEFT JOIN (SELECT t2.IdCampaign, 
                                   t2.IdSocialNetwork, 
                                   MAX(t2.UniqueShareNetCount) AS TopUniqueShareCount, 
                                   t4.UniqueShareCount 
                            FROM   (SELECT IdCampaign, 
                                           IdSocialNetwork, 
                                           Count(IdSubscriber) AS UniqueShareNetCount 
                                    FROM   dbo.SocialNetworkShareTracking 
                                    WHERE  IdCampaign = @IdCampaign 
                                    GROUP  BY IdCampaign, 
                                              IdSocialNetwork)t2 
                                   JOIN (SELECT IdCampaign, 
                                                MAX(UniqueShareNetCount) AS UniqueShareNetCount,
                                                SUM(UniqueShareNetCount) AS UniqueShareCount 
                                         FROM   (SELECT IdCampaign, 
                                                        Count(IdSubscriber) AS UniqueShareNetCount
                                                 FROM   dbo.SocialNetworkShareTracking 
                                                 WHERE  IdCampaign = @IdCampaign 
                                                 GROUP  BY IdCampaign, 
                                                           IdSocialNetwork)t3 
                                         GROUP  BY IdCampaign)t4 
                                     ON t2.IdCampaign = t4.IdCampaign 
                                        AND t2.UniqueShareNetCount = t4.UniqueShareNetCount 
                            GROUP  BY t2.IdCampaign, 
                                      t2.IdSocialNetwork, 
                                      t4.UniqueShareCount) t5 
                        ON c.IdCampaign = t5.IdCampaign 
          WHERE  c.IdCampaign = @IdCampaign 
                 AND c.IdUser = @IdUser 
      END 

GO 