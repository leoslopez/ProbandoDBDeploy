/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberListByCampaignDeliveryStatusAndFilter_A]    Script Date: 08/07/2013 11:43:58 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberListByCampaignDeliveryStatusAndFilter_A]
@IdCampaign INT,
@Status INT, -- NotOpened = 0,Bounced = 1,Opened = 2,NotSent = 3
@Name VARCHAR(300),
@emailFilter VARCHAR(50),
@firstnameFilter VARCHAR(50),
@lastnameFilter VARCHAR(50)
AS
	-- TODO: This must be implemented after attacking "Segments"
	-- More info: DPLR-2625
RETURN 0