CREATE PROCEDURE [dbo].[ReportExport_DeleteReportRequest]
@IdReportRequest int,
@IdUser int 
AS
SET NOCOUNT ON

UPDATE [dbo].[ReportRequest] WITH(ROWLOCK)
SET Status = 'Erased',
Progress = 0 
FROM [dbo].[ReportRequest] RR 
INNER JOIN [dbo].[Campaign] C 
ON C.IdCampaign = RR.IdCampaign
WHERE C.IdUser = @IdUser AND IdRequest = @IdReportRequest
GO