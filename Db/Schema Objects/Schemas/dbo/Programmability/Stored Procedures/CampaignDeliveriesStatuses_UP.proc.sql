CREATE PROCEDURE [dbo].[CampaignDeliveriesStatuses_UP] 
@Idcampaign int, 
@Idsubscriber bigint, 
@IddeliveryStatus int, 
@date datetime, 
@languageId int 
AS 
Update dbo.CampaignDeliveriesOpenInfo WITH(ROWLOCK) 
Set IdDeliveryStatus =@IdDeliveryStatus,
date = @date
WHERE IdCampaign = @IdCampaign and IdSubscriber =@IdSubscriber

IF (@@ROWCOUNT=0 AND @IddeliveryStatus=100) 
BEGIN 
insert Into dbo.CampaignDeliveriesOpenInfo WITH(ROWLOCK) 
(IdCampaign, IdSubscriber, IdDeliveryStatus, [date], [count]) 
VALUES (@Idcampaign, @Idsubscriber, @IddeliveryStatus, @date, 1) 
END