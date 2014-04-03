ALTER PROCEDURE [dbo].[Campaigns_CampaignActive_UP]
@Active bit,
@IdCampaign int
AS

DECLARE @idTestAB int;
SELECT @idTestAB = idTestAb FROM Campaign WHERE IdCampaign = @IdCampaign

IF(@idTestAB IS NULL)
BEGIN
	UPDATE Campaign WITH(ROWLOCK)
	SET Active = @Active,
	DesactiveDate = GETDATE()
	WHERE IdCampaign = @IdCampaign
END
ELSE
BEGIN
	UPDATE Campaign WITH(ROWLOCK)
	SET Active = @Active,
	DesactiveDate = GETDATE()
	WHERE IdTestAB = @idTestAB
END

GO
PRINT N'[dbo].[Campaigns_CampaignActive_UP] was altered.';