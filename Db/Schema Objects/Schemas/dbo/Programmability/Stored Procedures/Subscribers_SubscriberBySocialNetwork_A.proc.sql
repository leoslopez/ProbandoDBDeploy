/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberBySocialNetwork_A]    Script Date: 08/07/2013 11:42:02 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberBySocialNetwork_A]
@CampaignID int,
@SocialNetworkID int,
@filteredListName varchar(100)
AS
	-- TODO: This must be implemented after attacking "Segments"
	-- More info: DPLR-2646
RETURN 0