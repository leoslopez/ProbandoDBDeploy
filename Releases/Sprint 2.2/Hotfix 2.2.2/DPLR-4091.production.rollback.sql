-- =============================================
-- Script Template
-- =============================================

--Needed to show the user name on the mail sended by report export.
ALTER PROCEDURE [dbo].[Campaigns_CampaignsForEmailAlert_GX]
@IdCampaign int,
@CampaignStatus int
AS
SELECT C.[Name], C.[Subject], C.UTCSentDate
FROM dbo.Campaign C
WHERE C.IdCampaign=@IdCampaign
GO

UPDATE TypeDescription
SET IdLanguage = CASE 
	WHEN (IdLanguage = 1) THEN 2
	WHEN (IdLanguage = 2) THEN 1
	ELSE IdLanguage
END

UPDATE ReportExportHeader
SET IdLanguage = CASE 
	WHEN (IdLanguage = 1) THEN 2
	WHEN (IdLanguage = 2) THEN 1
	ELSE IdLanguage
END
GO
