/****** Object:  StoredProcedure [dbo].[ReportExport_RequestByCampaign_GX]    Script Date: 08/07/2013 11:36:54 ******/

CREATE PROCEDURE [dbo].[ReportExport_RequestByCampaign_GX]
@IdCampaign int
AS
SELECT IdRequest, ReportType, RequestExportType, [Status], [TimeStamp]
, Progress, URLPath, [FileName], EmailAlert, Filter, FirstNameFilter
, LastNameFilter, EMailFilter, [Language]
FROM ReportRequest WITH(NOLOCK)
WHERE IdCampaign = @IdCampaign
AND Active = 1
ORDER BY [TimeStamp] desc
GO