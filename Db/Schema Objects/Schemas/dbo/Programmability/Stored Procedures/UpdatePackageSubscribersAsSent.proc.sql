
CREATE PROCEDURE [dbo].[UpdatePackageSubscribersAsSent] @IdCampaign INT, 
                                                       @Table      TYPECAMPAIGNDELIVERIESUPDATE READONLY
AS 
    UPDATE dbo.CampaignXSubscriberStatus WITH(PAGLOCK) 
    SET    Sent = 1 
    FROM   dbo.CampaignXSubscriberStatus cxss 
           JOIN @Table t 
             ON cxss.IdSubscriber = t.IdSubscriber 
    WHERE  cxss.IdCampaign = @IdCampaign