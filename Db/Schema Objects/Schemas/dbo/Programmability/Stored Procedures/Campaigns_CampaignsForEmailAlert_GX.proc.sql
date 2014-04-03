		
-- =============================================
-- Script Template
-- =============================================

--Needed to show the user name on the mail sended by report export.
CREATE PROCEDURE [dbo].[Campaigns_CampaignsForEmailAlert_GX]
@IdCampaign int,
@CampaignStatus int
AS
SELECT C.[Name], C.[Subject], C.UTCSentDate, U.Email
FROM dbo.Campaign C
LEFT JOIN [User] U on U.IdUser = C.IdUser
WHERE C.IdCampaign=@IdCampaign