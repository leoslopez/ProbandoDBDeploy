CREATE PROCEDURE [dbo].[CampaignDeliveryStatusExistence_G] 
@IDcampaign int, 
@Idsubscriber bigint, 
@status int 
AS 
declare @aux int 
select @aux=CASE IDDeliveryStatus 
WHEN 0 then 20 
ELSE IDDeliveryStatus End 
FROM dbo.CampaignDeliveriesOpenInfo WITH(NOLOCK) 
where Idcampaign = @IDcampaign and Idsubscriber = @Idsubscriber

IF (@aux is null) 
Select 0 
ELSE 
Select @aux 