CREATE PROCEDURE [dbo].[GetAmountSubscribersToSend] (@IdCampaign int) 
AS 
	SET NOCOUNT ON;
	
	SELECT COUNT(DISTINCT S.IdSubscriber) as Result FROM SubscribersListXCampaign SLXC
	JOIN SubscriberXList SXL ON SLXC.IdSubscribersList = SXL.IdSubscribersList
	JOIN Subscriber S ON S.IdSubscriber = SXL.IdSubscriber
	WHERE SLXC.IdCampaign = @IdCampaign
	AND S.IdSubscribersStatus IN (1,2) AND sxl.Active = 1