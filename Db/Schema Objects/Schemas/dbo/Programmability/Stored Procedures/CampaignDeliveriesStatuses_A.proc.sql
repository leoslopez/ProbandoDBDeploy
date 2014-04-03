CREATE PROCEDURE [dbo].[CampaignDeliveriesStatuses_A] 
@Idcampaign int, 
@Idsubscriber bigint, 
@IddeliveryStatus int, 
@date datetime, 
@languageId int 
AS 
if ( 
(select IDcampaign from Campaign WITH(NOLOCK) where IDcampaign = @Idcampaign) > 0 
AND 
(select IdSubscriber from Subscriber WITH(NOLOCK) 
where IdSubscriber=@Idsubscriber AND IdSubscribersStatus<3) > 0 ) 
BEGIN 
insert Into dbo.CampaignDeliveriesOpenInfo WITH(ROWLOCK) 
(IdCampaign, IdSubscriber, IdDeliveryStatus, date, [count]) 
VALUES (@Idcampaign, @Idsubscriber, @IddeliveryStatus, @date,0)

Select @Idcampaign 
END 
ELSE 
BEGIN 
Select 1 
END 