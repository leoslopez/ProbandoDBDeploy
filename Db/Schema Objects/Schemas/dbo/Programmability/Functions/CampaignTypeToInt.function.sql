CREATE FUNCTION [dbo].[CampaignTypeToInt]
(
	@CampaignType VARCHAR(30),
	@ContentType INT
)
RETURNS int
AS
BEGIN
	IF (@ContentType = 1)
		return 4
	IF (@CampaignType = 'SOCIAL')
		return 1
	return 2
END