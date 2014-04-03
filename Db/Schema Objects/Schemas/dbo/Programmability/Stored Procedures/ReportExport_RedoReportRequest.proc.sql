/****** Object:  StoredProcedure [dbo].[ReportExport_RedoReportRequest]    Script Date: 08/07/2013 11:36:00 ******/

CREATE PROCEDURE [dbo].[ReportExport_RedoReportRequest]
@IdReportRequest int,
@IdUser int 
AS
BEGIN
UPDATE [dbo].[ReportRequest] WITH(ROWLOCK)
SET Status = 'Queued', Progress = 0 FROM [dbo].[ReportRequest] RR 
INNER JOIN [dbo].[Campaign] C ON C.IdCampaign = RR.IdCampaign
WHERE C.IdUser = @IdUser
AND IdRequest = @IdReportRequest
END
GO