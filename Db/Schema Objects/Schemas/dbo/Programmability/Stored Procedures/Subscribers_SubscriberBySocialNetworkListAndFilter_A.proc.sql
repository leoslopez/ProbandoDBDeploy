/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberBySocialNetworkListAndFilter_A]    Script Date: 08/07/2013 11:42:26 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberBySocialNetworkListAndFilter_A]
@CampaignID int,
@socialNetworkList varchar(300), /*Lista Id Social Networks por Coma*/
@filteredListName varchar(300),
@emailFilter varchar(100),
@firstNameFilter varchar(100),
@lastNameFilter varchar(100)
AS
	-- TODO: This must be implemented after attacking "Segments"
	-- More info: DPLR-2647
RETURN 0