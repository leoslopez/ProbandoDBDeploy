CREATE PROCEDURE [dbo].[CampaignSplitedUpdate]
	@IdCampaign INT
AS
	UPDATE dbo.Campaign
	SET DMSSplited = 1,
		UTCDMSLastUpdate = GETUTCDATE(),
		Queued = 0
	WHERE IdCampaign = @IdCampaign