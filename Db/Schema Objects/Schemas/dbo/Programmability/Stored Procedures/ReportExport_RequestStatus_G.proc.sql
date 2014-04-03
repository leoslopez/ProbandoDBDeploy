/****** Object:  StoredProcedure [dbo].[ReportExport_RequestStatus_G]    Script Date: 08/07/2013 11:37:38 ******/

CREATE PROCEDURE [dbo].[ReportExport_RequestStatus_G]
@IdRequest int
AS
BEGIN
  SELECT [Status] FROM ReportRequest
  WHERE IdRequest = @IdRequest
END