/****** Object:  StoredProcedure [dbo].[Reports_ReportPageByCampaignType_GX]    Script Date: 08/07/2013 11:38:53 ******/

CREATE PROCEDURE [dbo].[Reports_ReportPageByCampaignType_GX]
@IdCampaignType int
AS
SELECT IdReportPage
FROM ReportPageByCampaignType WITH(NOLOCK)
WHERE IdCampaignType = @IdCampaignType
GO