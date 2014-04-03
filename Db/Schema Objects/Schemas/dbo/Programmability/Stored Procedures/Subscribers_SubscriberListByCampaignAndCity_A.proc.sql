/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberListByCampaignAndCity_A]    Script Date: 08/07/2013 11:43:19 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberListByCampaignAndCity_A]
@CampaignID INT,
@CountryCode VARCHAR(2),
@CityName varchar(50),
@filteredListName VARCHAR(300)
AS
	-- TODO: This must be implemented after attacking "Segments"
	-- More info: DPLR-2636
RETURN 0