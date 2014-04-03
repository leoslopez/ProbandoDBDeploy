/****** Object:  StoredProcedure [dbo].[ReportExport_RequestCancel_UP]    Script Date: 08/07/2013 11:37:00 ******/

CREATE PROCEDURE [dbo].[ReportExport_RequestCancel_UP]
@IdRequest int,
@Status varchar(50)
AS
BEGIN
UPDATE ReportRequest WITH(ROWLOCK)
SET [Status] = @Status, Active = 0
WHERE IdRequest = @IdRequest
END
GO