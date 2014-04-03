CREATE PROCEDURE [dbo].[Mucama] 
AS 
  BEGIN 
      DECLARE @CampaignsToClean TABLE 
        ( 
           IdCampaign INT, 
           IdTestAB   INT 
        ) 

      --PRINT 'TotalCampañas Encontradas: '  
      INSERT INTO @CampaignsToClean 
      SELECT TOP 1000 IdCampaign, 
             IdTestAB 
      FROM   dbo.Campaign 
      WHERE  Active = 0 
             AND Status <> 9 

      UPDATE dbo.Campaign 
      SET    TotalSubscribersLists = Deliveries.TotalSent, 
             HardBouncedMailCount = Deliveries.Hard, 
             SoftBouncedMailCount = Deliveries.Soft, 
             UnopenedMailCount = Deliveries.NotOpen, 
             TotalOpenedMailCount = Deliveries.TotalOpen, 
             DistinctOpenedMailCount = Deliveries.DistinctOpen, 
             UnsubscriptionsCount = Unsub.Total, 
             LastOpenedEmailDate = LastDate.Date, 
             ForwardedEmailsCount = ff.Total 
      FROM   dbo.Campaign c 
             JOIN @CampaignsToClean ctc 
               ON c.IdCampaign = ctc.IdCampaign 
             JOIN (SELECT ctc.IdCampaign, 
                          ISNULL(COUNT(cdoi.IdSubscriber), 0) TotalSent, 
                          ISNULL(COUNT(CASE 
                                         WHEN cdoi.IdDeliveryStatus IN ( 2, 8 ) THEN 1 
                                         ELSE NULL 
                                       END), 0)               Hard, 
                          ISNULL(COUNT(CASE 
                                         WHEN cdoi.IdDeliveryStatus IN ( 1, 3, 4, 5, 
                                                                         6, 7 ) THEN 1 
                                         ELSE NULL 
                                       END), 0)               Soft, 
                          ISNULL(COUNT(CASE 
                                         WHEN cdoi.IdDeliveryStatus = 0 THEN 1 
                                         ELSE NULL 
                                       END), 0)               NotOpen, 
                          ISNULL(SUM(CASE 
                                       WHEN cdoi.IdDeliveryStatus = 100 THEN cdoi.Count 
                                       ELSE 0 
                                     END), 0)                 TotalOpen, 
                          ISNULL(COUNT(CASE 
                                         WHEN cdoi.IdDeliveryStatus = 100 THEN 1 
                                         ELSE NULL 
                                       END), 0)               DistinctOpen 
                   FROM   @CampaignsToClean ctc 
                          LEFT JOIN dbo.CampaignDeliveriesOpenInfo cdoi 
                                 ON cdoi.IdCampaign = ctc.IdCampaign 
                   GROUP  BY ctc.IdCampaign)Deliveries 
               ON Deliveries.IdCampaign = ctc.IdCampaign 
             JOIN (SELECT COUNT(s.IdSubscriber) Total, 
                          ctc.IdCampaign 
                   FROM   @CampaignsToClean ctc 
                          LEFT JOIN dbo.CampaignDeliveriesOpenInfo cdoi 
                                 ON cdoi.IdCampaign = ctc.IdCampaign 
                          LEFT JOIN dbo.Subscriber s 
                                 ON s.IdSubscriber = cdoi.IdSubscriber 
                                    AND s.IdCampaign = cdoi.IdCampaign 
                   GROUP  BY ctc.IdCampaign) Unsub 
               ON Unsub.IdCampaign = ctc.IdCampaign 
             LEFT JOIN (SELECT ctc.IdCampaign, 
                               MAX(cdoi.Date) Date 
                        FROM   @CampaignsToClean ctc 
                               LEFT JOIN dbo.CampaignDeliveriesOpenInfo cdoi 
                                      ON cdoi.IdCampaign = ctc.IdCampaign 
                        WHERE  cdoi.IdDeliveryStatus = 100 
                        GROUP  BY ctc.IdCampaign) LastDate 
                    ON LastDate.IdCampaign = ctc.IdCampaign 
             JOIN (SELECT ctc.IdCampaign, 
                          COUNT(ForwardID) Total 
                   FROM   @CampaignsToClean ctc 
                          LEFT JOIN dbo.ForwardFriend ff 
                                 ON ff.IdCampaign = ctc.IdCampaign 
                   GROUP  BY ctc.IdCampaign) FF 
               ON FF.IdCampaign = ctc.IdCampaign 

      DELETE FROM dbo.CampaignDeliveriesOpenInfo 
      FROM   dbo.CampaignDeliveriesOpenInfo cdoi 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = cdoi.IdCampaign 

      DELETE FROM dbo.CampaignBig 
      FROM   dbo.CampaignBig c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.CampaignDeliveriesOpenInfoTemp 
      FROM   dbo.CampaignDeliveriesOpenInfoTemp c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.CampaignDeliveriesSocialOpenInfo 
      FROM   dbo.CampaignDeliveriesSocialOpenInfo c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.CampaignFieldUsed 
      FROM   dbo.CampaignFieldUsed c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.CampaignStatistic 
      FROM   dbo.CampaignStatistic c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.ContentXField 
      FROM   dbo.ContentXField c 
             JOIN dbo.Content co 
               ON c.IdContent = co.IdCampaign 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = co.IdCampaign 

      DELETE FROM dbo.Content 
      FROM   dbo.Content c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.Filter 
      FROM   dbo.Filter f 
             JOIN dbo.FilterByCampaignDeliveries c 
               ON f.IdFilter = c.IdFilter 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.FilterByCampaignDeliveries 
      FROM   dbo.FilterByCampaignDeliveries c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.LinkTracking 
      FROM   dbo.LinkTracking lt 
             JOIN dbo.Link l 
               ON lt.IdLink = l.IdLink 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = l.IdCampaign 

      DELETE FROM dbo.Link 
      FROM   dbo.Link c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.MailConfirmationXCampaign 
      FROM   dbo.MailConfirmationXCampaign c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.SocialFanPageAutoPublishXCampaign 
      FROM   dbo.SocialFanPageAutoPublishXCampaign c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.SocialNetworkAutoPublishXCampaign 
      FROM   dbo.SocialNetworkAutoPublishXCampaign c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.SocialNetworkShareXCampaign 
      FROM   dbo.SocialNetworkShareXCampaign c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.SocialNetworkExtrasXCampaign 
      FROM   dbo.SocialNetworkExtrasXCampaign c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.SubscribersListXCampaign 
      FROM   dbo.SubscribersListXCampaign c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DELETE FROM dbo.TestABSubscriberList 
      FROM   dbo.TestABSubscriberList t 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdTestAB = t.IdTestAB 
      WHERE  ctc.IdTestAB IS NOT NULL 

      /*Summarizar y actualizar*/ 
      UPDATE dbo.Campaign 
      SET    Status = 9 
      FROM   dbo.Campaign c 
             JOIN @CampaignsToClean ctc 
               ON ctc.IdCampaign = c.IdCampaign 

      DECLARE @ListsToClean TABLE 
        ( 
           IdSubscribersList INT 
        ) 

      --PRINT 'Total Listas Encontradas: '  
      INSERT INTO @ListsToClean 
      SELECT TOP 1000 IdSubscribersList 
      FROM   dbo.SubscribersList 
      WHERE  Active = 0 

      DELETE FROM dbo.SubscriberXList 
      FROM   dbo.SubscriberXList sxl 
             JOIN @ListsToClean ltc 
               ON sxl.IdSubscribersList = ltc.IdSubscribersList 

      DELETE FROM dbo.ImportError 
      FROM   dbo.ImportError ie 
             JOIN dbo.ImportResult ire 
               ON ie.IdImportResult = ire.IdImportResult 
             JOIN dbo.ImportTask it 
               ON ire.IdImportResult = it.IdImportResult 
             JOIN dbo.ImportRequest ir 
               ON it.IdImportRequest = ir.IdImportRequest 
             JOIN @ListsToClean ltc 
               ON ir.IdSubscriberList = ltc.IdSubscribersList 

      DELETE FROM dbo.ImportTask 
      FROM   dbo.ImportTask it 
             JOIN dbo.ImportRequest ir 
               ON it.IdImportRequest = ir.IdImportRequest 
             JOIN @ListsToClean ltc 
               ON ir.IdSubscriberList = ltc.IdSubscribersList 

      DELETE FROM dbo.ImportResult 
      FROM   dbo.ImportResult ire 
             JOIN dbo.ImportTask it 
               ON it.IdImportResult = ire.IdImportResult 
             JOIN dbo.ImportRequest ir 
               ON it.IdImportRequest = ir.IdImportRequest 
             JOIN @ListsToClean ltc 
               ON ir.IdSubscriberList = ltc.IdSubscribersList 

      DELETE FROM dbo.ImportRequest 
      FROM   dbo.ImportRequest ir 
             JOIN @ListsToClean ltc 
               ON ir.IdSubscriberList = ltc.IdSubscribersList 

      DELETE FROM dbo.SubscribersList 
      FROM   dbo.SubscribersList sl 
             JOIN @ListsToClean ltc 
               ON sl.IdSubscribersList = ltc.IdSubscribersList 
  END 