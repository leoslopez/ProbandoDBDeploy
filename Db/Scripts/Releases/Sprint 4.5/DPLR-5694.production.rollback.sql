ALTER PROCEDURE [dbo].[Campaigns_CampaignActive_UP]
@Active bit,
@IdCampaign int
AS
UPDATE Campaign WITH(ROWLOCK)
SET Active = @Active,
DesactiveDate = GETDATE()
WHERE IdCampaign = @IdCampaign

GO
PRINT N'The rollback for [dbo].[Campaigns_CampaignActive_UP] was done.';