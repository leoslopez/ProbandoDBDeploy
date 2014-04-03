
CREATE PROCEDURE [dbo].[Campaigns_CampaignSummaryByID_GX] @IdCampaign INT, 
                                                         @StatusID   INT 
AS 
    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   GetTestABSet(@IdCampaign); 

    SELECT TotalClickedMailCount, 
           DistinctClickedMailCount, 
           DistinctOpenedMailCount, 
           ForwardedEmailsCount, 
           LastClickedEmailDate, 
           LastOpenedEmailDate, 
           UnsubscriptionsCount, 
           TotalOpenedMailCount, 
           UniqueSubscriberNetCount, 
           TotalShareCount, 
           SocialNetworkID, 
           SNSubscriberCount, 
           SNShareCount, 
           FBLikeCount 
    FROM   (SELECT SUM(result.TotalClickedMailCount)    TotalClickedMailCount, 
                   SUM(result.DistinctClickedMailCount) DistinctClickedMailCount, 
                   SUM(result.DistinctOpenedMailCount)  DistinctOpenedMailCount, 
                   SUM(result.ForwardedEmailsCount)     ForwardedEmailsCount, 
                   MAX(result.LastClickedEmailDate)     LastClickedEmailDate, 
                   MAX(result.LastOpenedEmailDate)      LastOpenedEmailDate, 
                   SUM(result.UnsubscriptionsCount)     UnsubscriptionsCount, 
                   SUM(result.TotalOpenedMailCount)     TotalOpenedMailCount, 
                   SUM(result.UniqueSubscriberNetCount) UniqueSubscriberNetCount, 
                   SUM(result.TotalShareCount)          TotalShareCount, 
                   MAX(result.SocialNetworkID)          SocialNetworkID, 
                   SUM(result.SNSubscriberCount)        SNSubscriberCount, 
                   SUM(result.SNShareCount)             SNShareCount, 
                   SUM(result.FBLikeCount)              FBLikeCount 
            FROM   (SELECT ISNULL(CLT.TotalClickedMailCount, 0)    as TotalClickedMailCount, 
                           ISNULL(CLT.DistinctClickedMailCount, 0) as DistinctClickedMailCount,
                           ISNULL(OPENS.DistinctOpenedMailCount, 0)as DistinctOpenedMailCount,
                           ISNULL(F.ForwardedEmailsCount, 0)       as ForwardedEmailsCount, 
                           CLT.LastClickedEmailDate, 
                           OPENS.LastOpenedEmailDate, 
                           ISNULL(S.UnsubscriptionsCount, 0)       as UnsubscriptionsCount, 
                           ISNULL(OPENS.TotalOpenedMailCount, 0)   as TotalOpenedMailCount, 
                           ISNULL(t5.UniqueSubscriberNetCount, 0)  as UniqueSubscriberNetCount,
                           ISNULL(t5.TotalShareCount, 0)           as TotalShareCount, 
                           ISNULL(t5.IdSocialNetwork, 1)           as SocialNetworkID, 
                           ISNULL(t5.SNSubscriberCount, 0)         as SNSubscriberCount, 
                           ISNULL(t5.SNShareCount, 1)              SNShareCount, 
                           ISNULL(FB.FBLikeCount, 0)               FBLikeCount 
                    FROM   @t t 
                           JOIN (SELECT CDU.IdCampaign, 
                                        COUNT(ISNULL(CDU.Count, 1)) DistinctOpenedMailCount, 
                                        SUM(CASE CDU.IdDeliveryStatus 
                                              WHEN 100 THEN ISNULL(CDU.Count, 1) 
                                            END)                    TotalOpenedMailCount, 
                                        MAX(cdu.Date)               LastOpenedEmailDate 
                                 FROM   dbo.CampaignDeliveriesOpenInfo CDU WITH(NOLOCK) 
                                 WHERE  CDU.IdDeliveryStatus = 100 
                                 GROUP  BY CDU.IdCampaign, 
                                           CDU.IdDeliveryStatus) OPENS 
                             ON t.IdCampaign = OPENS.IdCampaign 
                           LEFT JOIN (SELECT L.IdCampaign, 
                                             SUM(ISNULL(LT.Count, 0))   TotalClickedMailCount,
                                             COUNT(ISNULL(LT.Count, 0)) DistinctClickedMailCount,
                                             MAX([Date])                LastClickedEmailDate 
                                      FROM   dbo.Link L WITH(NOLOCK) 
                                             JOIN dbo.LinkTracking LT WITH(NOLOCK) 
                                               ON L.IdLink = LT.IdLink 
                                      GROUP  BY L.IdCampaign) CLT 
                                  ON t.IdCampaign = CLT.IdCampaign 
                           LEFT JOIN (SELECT IdCampaign, 
                                             COUNT(ForwardID) ForwardedEmailsCount 
                                      FROM   dbo.ForwardFriend F WITH(NOLOCK) 
                                      GROUP  BY F.IdCampaign) F 
                                  ON t.IdCampaign = F.IdCampaign 
                           LEFT JOIN (SELECT s.IdCampaign, 
                                             COUNT(IdSubscriber) UnsubscriptionsCount 
                                      FROM   dbo.Subscriber s WITH(NOLOCK) 
                                      GROUP  BY s.IdCampaign) S 
                                  ON t.IdCampaign = S.IdCampaign 
                           LEFT JOIN (SELECT x.IdCampaign, 
                                             x.UniqueSubscriberNetCount, 
                                             x.TotalShareCount, 
                                             w.IdSocialNetwork, 
                                             w.SNSubscriberCount, 
                                             w.SNShareCount 
                                      FROM   (SELECT so.IdCampaign, 
                                                     Count(DISTINCT so.IdSubscriber) AS UniqueSubscriberNetCount,
                                                     SUM(so.Count)                   as TotalShareCount
                                              FROM   @t t 
                                                     JOIN dbo.SocialNetworkShareTracking so WITH(NOLOCK)
                                                       ON t.IdCampaign = so.IdCampaign 
                                              GROUP  BY so.IdCampaign)x 
                                             JOIN(SELECT TOP 1 t1.IdCampaign, 
                                                               t2.IdSocialNetwork, 
                                                               t2.SNSubscriberCount, 
                                                               t2.SNShareCount 
                                                  FROM   (SELECT IdCampaign, 
                                                                 MAX(SNShareCount) SNShareCount
                                                          FROM   (SELECT sn.IdCampaign, 
                                                                         IdSocialNetwork, 
                                                                         Count(DISTINCT sn.IdSubscriber) AS SNSubscriberCount,
                                                                         SUM(sn.Count)                   as SNShareCount
                                                                  FROM   @t t 
                                                                         JOIN dbo.SocialNetworkShareTracking sn WITH(NOLOCK)
                                                                           on t.IdCampaign = sn.IdCampaign
                                                                  GROUP  BY sn.IdCampaign, 
                                                                            IdSocialNetwork)t
                                                          GROUP  BY IdCampaign) t1 
                                                         JOIN (SELECT snst.IdCampaign, 
                                                                      snst.IdSocialNetwork, 
                                                                      Count(DISTINCT snst.IdSubscriber) AS SNSubscriberCount,
                                                                      SUM(snst.Count)                   as SNShareCount
                                                               FROM   @t t 
                                                                      JOIN dbo.SocialNetworkShareTracking snst WITH(NOLOCK)
                                                                        on t.IdCampaign = snst.IdCampaign
                                                               GROUP  BY snst.IdCampaign, 
                                                                         IdSocialNetwork)t2 
                                                           ON t1.IdCampaign = t2.IdCampaign 
                                                              AND t1.SNShareCount = t2.SNShareCount)w
                                               ON x.IdCampaign = w.IdCampaign)t5 
                                  ON t.IdCampaign = t5.IdCampaign 
                           LEFT JOIN (SELECT IdCampaign, 
                                             SUM(SNET.Count) as FBLikeCount 
                                      FROM   SocialNetworkExtrasTracking SNET WITH(NOLOCK) 
                                             LEFT JOIN SocialNetworkExtras SNE WITH(NOLOCK) 
                                                    ON SNET.IdSocialNetworkExtras = SNE.IdSocialNetwork
                                      WHERE  SNE.Name = 'facebook-like' 
                                      GROUP  BY SNET.IdCampaign) FB 
                                  ON t.IdCampaign = FB.IdCampaign) as result)t 
    where  TotalOpenedMailCount IS NOT NULL 

GO 