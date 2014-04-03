/****** Object:  StoredProcedure [dbo].[ReportExport_ReportHeaderByLaguageAndReportType_GX]    Script Date: 08/07/2013 11:36:12 ******/

CREATE PROCEDURE [dbo].[ReportExport_ReportHeaderByLaguageAndReportType_GX] 
@IdLanguage int, 
@Idreporttype int 
AS 
SELECT HeaderPosition, [Description] 
FROM ReportExportHeader WITH(NOLOCK) 
WHERE IdLanguage = @IdLanguage 
AND IdReportType = @IdReporttype 
ORDER BY HeaderPosition
