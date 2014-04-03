/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberByUserMailAgent_A]    Script Date: 08/07/2013 11:42:32 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberByUserMailAgent_A]
@CampaignID int,
@UserMailAgentType int,
@filteredListName varchar(100)
AS
	-- TODO: This must be implemented after attacking "Segments"
	-- More info: DPLR-2648
RETURN 0