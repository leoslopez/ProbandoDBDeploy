/****** Object:  StoredProcedure [dbo].[ReportExport_Request_G]    Script Date: 08/07/2013 11:36:32 ******/

CREATE PROCEDURE [dbo].[ReportExport_Request_G]
@IdRequest int
AS
SELECT IdCampaign, ReportType, RequestExportType, [TimeStamp],
[Status], Progress, URLPath, [FileName] , Filter, FirstNameFilter,
LastNameFilter, EmailFilter, EmailAlert, [Language], IDCampaignStatus
FROM ReportRequest WITH(NOLOCK)
WHERE IdRequest = @IdRequest
GO