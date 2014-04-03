CREATE PROCEDURE [dbo].[CampaignDeliveriesUpdateQueued_UP] @Idcampaign int, 
                                                         @queued     bit 
AS 
    UPDATE Campaign WITH(ROWLOCK) 
    SET    Queued = @queued, 
           DeliveryType = 2 
    WHERE  IdCampaign = @Idcampaign 

GO 