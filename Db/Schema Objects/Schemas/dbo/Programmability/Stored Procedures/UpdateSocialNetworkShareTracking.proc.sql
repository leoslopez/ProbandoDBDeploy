/****** Object:  StoredProcedure [dbo].[UpdateSocialNetworkShareTracking]    Script Date: 08/07/2013 11:45:26 ******/

/*******************************************************************************************
Procedure:		UpdateSocialNetworkShareTracking
				(Copyright © 2012 Making Sense. All rights reserved.)
Purpose:		Increment the shared social count for this subscriber and campaign.
Written by:		Esteban Asla
Tested on:		SQL Server 2008 R2
Date created:	September 12th 2012
*******************************************************************************************/
CREATE PROCEDURE [dbo].[UpdateSocialNetworkShareTracking]
	@IdSubscriber int,		-- Subscriber that opened the campaign
	@IdSocialNetwork int,	-- The shared social network
	@IdCampaign int,		-- The campaign
	@OpenDate datetime		-- Date and time when the share was clicked by subscriber
AS
BEGIN
IF @IdSubscriber = -1
BEGIN
	SET @IdSubscriber = NULL	
END
SET NOCOUNT ON
-- If a record exists, increment a counter by one; otherwise, insert the record with a value of one. The following MERGE statement wraps this logic and uses the HOLDLOCK hint to avoid race conditions.
MERGE SocialNetworkShareTracking AS [Target]
USING (SELECT 1 AS One) AS [Source]
ON ([Target].IdSocialNetwork = @IdSocialNetwork AND [Target].IdSubscriber = @IdSubscriber AND [Target].IdCampaign = @IdCampaign)
WHEN MATCHED THEN
	UPDATE
	SET [Target].Count = [Target].Count + 1,
	[Target].Date = @OpenDate
WHEN NOT MATCHED THEN
	INSERT (IdSubscriber, IdSocialNetwork, IdCampaign, Count, Date)
	VALUES (@IdSubscriber, @IdSocialNetwork, @IdCampaign, 1, @OpenDate);
END