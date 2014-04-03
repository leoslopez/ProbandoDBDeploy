/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberListByCampaignAndCountry_A]    Script Date: 08/07/2013 11:43:24 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberListByCampaignAndCountry_A]
@CampaignID INT,
@CountryCode VARCHAR(2),
@filteredListName VARCHAR(300)
AS
	-- TODO: This must be implemented after attacking "Segments"
	-- More info: DPLR-2634
RETURN 0