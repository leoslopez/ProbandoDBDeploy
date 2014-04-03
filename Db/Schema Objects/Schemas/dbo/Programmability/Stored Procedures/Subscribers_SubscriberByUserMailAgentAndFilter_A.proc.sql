/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberByUserMailAgentAndFilter_A]    Script Date: 08/07/2013 11:42:43 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberByUserMailAgentAndFilter_A]
@CampaignID int,
@SocialNetworkID int,
@filteredListName varchar(100),
@EmailNameFilter varchar(100), 
@FirstNameFilter varchar(100), 
@LastNameFilter varchar(100)
AS
	-- TODO: This must be implemented after attacking "Segments"
	-- More info: DPLR-2650
RETURN 0