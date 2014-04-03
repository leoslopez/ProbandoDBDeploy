/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberListByCampaignCityAndFilter_A]    Script Date: 08/07/2013 11:43:41 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberListByCampaignCityAndFilter_A]
@CampaignID INT,
@CountryCode VARCHAR(2),
@CityName varchar(50),
@filteredListName VARCHAR(300),
@emailFilter varchar(50),
@firstnameFilter varchar(50),
@lastnameFilter varchar(50)
AS
	-- TODO: This must be implemented after attacking "Segments"
	-- More info: DPLR-2636
RETURN 0