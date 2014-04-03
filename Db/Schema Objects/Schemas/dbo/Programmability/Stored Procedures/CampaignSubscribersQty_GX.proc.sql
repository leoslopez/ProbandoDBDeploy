CREATE PROCEDURE [dbo].[CampaignSubscribersQty_GX] 
@IdCampaign int, 
@Status     int 
AS 
SET NOCOUNT ON

    IF ( @status = 4 ) 
      SELECT COUNT(DISTINCT S.IdSubscriber) 
      FROM   dbo.SubscribersListXCampaign slxc WITH (NOLOCK) 
             JOIN dbo.SubscriberXList sxl WITH (NOLOCK) 
               ON slxc.IdSubscribersList = sxl.IdSubscribersList 
             JOIN Subscriber s WITH (NOLOCK) 
               ON s.IdSubscriber = sxl.IdSubscriber 
      WHERE  ( slxc.Idcampaign = @Idcampaign ) 
             and ( S.IdSubscribersStatus < 3 ) 
             AND ( sxl.Active = 1 ) 
    ELSE 
      SELECT COUNT(IdSubscriber) 
      FROM   dbo.CampaignDeliveriesOpenInfo WITH(NOLOCK) 
      WHERE  IdCampaign = @Idcampaign 

GO 