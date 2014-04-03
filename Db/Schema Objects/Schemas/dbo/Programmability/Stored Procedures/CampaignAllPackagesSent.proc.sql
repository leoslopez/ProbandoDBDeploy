CREATE PROCEDURE [dbo].[CampaignAllPackagesSent] @IdCampaign INT 
AS 
    IF( EXISTS (SELECT CSS.IdSubscriber FROM dbo.CampaignXSubscriberStatus CSS
				JOIN Subscriber S ON S.IdSubscriber = CSS.IdSubscriber
				WHERE  CSS.IdCampaign = @IdCampaign
				AND    CSS.Sent = 0
				AND    S.IdSubscribersStatus < 3)) 
		SELECT 0 
	SELECT 1