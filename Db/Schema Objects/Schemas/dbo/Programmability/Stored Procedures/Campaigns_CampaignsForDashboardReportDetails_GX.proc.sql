
CREATE PROCEDURE [dbo].[Campaigns_CampaignsForDashboardReportDetails_GX] @IdCampaign     int, 
                                                                        @CampaignStatus int 
AS 
    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   GetTestABSet(@IdCampaign) 

    SELECT c.Name, 
           MAX(c.[Subject])                   [Subject], 
           c.ContentType, 
           SUM(OPENS.DistinctOpenedMailCount) DistinctOpenedMailCount, 
           SUM(OPENS.SoftBouncedMailCount)          SoftBouncedMailCount, 
           SUM(OPENS.HardBouncedMailCount)          HardBouncedMailCount, 
           SUM(OPENS.UnopenedMailCount)             UnopenedMailCount, 
           MIN(c.UTCSentDate)                 UTCSentDate, 
           SUM(F.ForwardedEmailsCount)        ForwardedEmailsCount, 
           SUM(OPENS.TotalOpenedMailCount)    TotalOpenedMailCount, 
           MAX(OPENS.LastOpenedEmailDate)     LastOpenedEmailDate, 
           SUM(CLT.DistinctClickedMailCount)  DistinctClickedMailCount, 
           SUM(CLT.TotalClickedMailCount)     TotalClickedMailCount, 
           MAX(CLT.LastClickedEmailDate)      LastClickedEmailDate, 
           SUM(s.UnsubscriptionsCount)        UnsubscriptionsCount, 
           c.CampaignType, 
           CAST(ISNULL(C.IdTestAB, 0) as BIT) as IsTestAB 
    FROM   @t t 
           JOIN dbo.Campaign c WITH(NOLOCK) 
             ON t.IdCampaign = c.IdCampaign 
           JOIN (SELECT CDU.IdCampaign, 
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
                              WHEN 100 THEN ISNULL(CDU.Count, 1) 
                            END)   TotalOpenedMailCount, 
                        COUNT(CASE IdDeliveryStatus 
                                WHEN 100 THEN 1 
                              END) DistinctOpenedMailCount, 
                        MAX(Date)  LastOpenedEmailDate 
                 FROM   dbo.CampaignDeliveriesOpenInfo CDU WITH(NOLOCK) 
                 GROUP  BY CDU.IdCampaign) OPENS 
             ON c.IdCampaign = OPENS.IdCampaign 
           LEFT JOIN (SELECT L.IdCampaign, 
                             SUM(ISNULL(LT.Count, 0))   TotalClickedMailCount, 
                             COUNT(ISNULL(LT.Count, 0)) DistinctClickedMailCount, 
                             MAX([Date])                LastClickedEmailDate 
                      FROM   dbo.Link L WITH(NOLOCK) 
                             JOIN dbo.LinkTracking LT WITH(NOLOCK) 
                               ON L.IdLink = LT.IdLink 
                      GROUP  BY L.IdCampaign) CLT 
                  ON OPENS.IdCampaign = CLT.IdCampaign 
           LEFT JOIN (SELECT F.IdCampaign, 
                             COUNT(ForwardID) ForwardedEmailsCount 
                      FROM   dbo.ForwardFriend F WITH(NOLOCK) 
                      GROUP  BY F.IdCampaign) F 
                  ON OPENS.IdCampaign = F.IdCampaign 
           LEFT JOIN (SELECT s.IdCampaign, 
                             COUNT(s.IdSubscriber) UnsubscriptionsCount 
                      FROM   dbo.Subscriber s WITH(NOLOCK) 
                      GROUP  BY s.IdCampaign) S 
                  ON OPENS.IdCampaign = S.IdCampaign 
    GROUP  by c.Name, 
              c.ContentType, 
              c.CampaignType, 
              C.IdTestAB 