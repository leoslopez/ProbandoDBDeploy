/****** Object:  StoredProcedure [dbo].[ReportExport_RequestMarkForDeletion_UP]    Script Date: 08/07/2013 11:37:17 ******/

CREATE PROCEDURE [dbo].[ReportExport_RequestMarkForDeletion_UP]
@IdRequest int,
@Status varchar(50)
AS
BEGIN
UPDATE ReportRequest WITH(ROWLOCK)
SET [Status] = @Status, Progress = 0
WHERE IdRequest = @IdRequest
END
GO