/****** Object:  StoredProcedure [dbo].[CampaignStatusByCampaignID_G]    Script Date: 08/07/2013 12:25:47 ******/

CREATE PROCEDURE [dbo].[CampaignStatusByCampaignID_G] 
(@IdCampaign int) 
AS 
SELECT Status 
FROM Campaign WITH(NOLOCK) 
WHERE IdCampaign = @IDCampaign