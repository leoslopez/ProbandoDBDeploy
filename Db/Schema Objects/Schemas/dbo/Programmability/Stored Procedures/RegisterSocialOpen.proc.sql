CREATE PROCEDURE [dbo].[RegisterSocialOpen]
	@IdCampaign int,		-- Campaign that was opened
	@IdSocialNetwork int,	-- The social network id
	@IdSubscriber int,		-- Subscriber that opened the campaign (can be null)
	@ipAddress varchar(50),	-- IP address of the subscriber
	@IpNumber bigint,		-- IP number from the IP address of the subscriber
	@IdPlatform int,		-- Platform of the subscriber
	@IdUserMailAgent int,	-- User agent of the subscriber
	@OpenDate datetime		-- Date and time when the campaing was opened by subscriber
AS
declare @locId int
SET @locId = (SELECT TOP 1 LocId FROM Blocks WITH(NOLOCK) 
		WHERE @IpNumber BETWEEN StartIpNum AND EndIpNum)
BEGIN
IF @IdSubscriber = -1
BEGIN
	SET @IdSubscriber = NULL	
END
SET NOCOUNT ON
-- If a record exists, increment a counter by one; otherwise, insert the record with a value of one. The following MERGE statement wraps this logic and uses the HOLDLOCK hint to avoid race conditions.
MERGE CampaignDeliveriesSocialOpenInfo AS [Target]
USING (SELECT 1 AS One) AS [Source]
ON ([Target].IdCampaign = @IdCampaign AND [Target].IdSocialNetwork = @IdSocialNetwork  AND ([Target].IdSubscriber = @IdSubscriber OR (@IdSubscriber IS NULL AND [Target].IdSubscriber IS NULL)))
WHEN MATCHED THEN
	UPDATE
	SET [Target].Count = [Target].Count + 1
WHEN NOT MATCHED THEN
	INSERT (IdCampaign, IdSocialNetwork, IdSubscriber, IpAddress, LocId, IdPlatform, IdUserMailAgent, Count, Date)
	VALUES (@IdCampaign, @IdSocialNetwork, @IdSubscriber, @ipAddress, @locId, @IdPlatform, @IdUserMailAgent, 1, @OpenDate);
END