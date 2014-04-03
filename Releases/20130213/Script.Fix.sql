-- =============================================
-- Script Template
-- =============================================
SET NOCOUNT ON;
--Fix problem related to issue http://jira.makingsense.com/browse/DPLR-4016

DECLARE @IdCampaing INT, @IdSocialNetwork INT;

DECLARE @AccessToken NVARCHAR(250)
DECLARE @SecretToken NVARCHAR(250)

DECLARE AutoPublishXCampaignCursor CURSOR FOR 
SELECT IdCampaign, IdSocialNetwork FROM SocialNetworkAutoPublishXCampaign
WHERE AccessToken IS NULL
AND SecretToken IS NULL

OPEN AutoPublishXCampaignCursor

FETCH NEXT FROM AutoPublishXCampaignCursor 
INTO  @IdCampaing, @IdSocialNetwork
	
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @AccessToken = NULL
	SET @SecretToken = NULL
	SELECT @AccessToken = ISNULL(APU.AccessToken, NULL), @SecretToken = ISNULL(APU.SecretToken, NULL) FROM SocialNetworkAutoPublishXUser APU
	INNER JOIN Campaign C ON APU.IdUser = C.IdUser
	WHERE APU.IdSocialNetwork = @IdSocialNetwork
	AND C.IdCampaign = @IdCampaing
	
	UPDATE SocialNetworkAutoPublishXCampaign 
	SET AccessToken = @AccessToken,
	SecretToken = @SecretToken
	WHERE IdCampaign = @IdCampaing
	AND IdSocialNetwork = @IdSocialNetwork
	
	FETCH NEXT FROM AutoPublishXCampaignCursor 
	INTO  @IdCampaing, @IdSocialNetwork
END
CLOSE AutoPublishXCampaignCursor;
DEALLOCATE AutoPublishXCampaignCursor;

DELETE FROM SocialNetworkAutoPublishXCampaign
WHERE AccessToken IS NULL
AND SecretToken IS NULL

