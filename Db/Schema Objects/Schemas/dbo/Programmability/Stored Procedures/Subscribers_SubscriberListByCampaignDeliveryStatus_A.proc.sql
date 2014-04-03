/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberListByCampaignDeliveryStatus_A]    Script Date: 08/07/2013 11:43:53 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberListByCampaignDeliveryStatus_A]
@IdCampaign INT,
@Status INT, -- NotOpened = 0,Bounced = 1,Opened = 2,NotSent = 3
@Name VARCHAR(300)
AS
	-- TODO: This must be implemented after attacking "Segments"
	-- More info: DPLR-2624
RETURN 0