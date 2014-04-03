/****** Object:  StoredProcedure [dbo].[ReportExport_RequestComplete_UP]    Script Date: 08/07/2013 11:37:06 ******/

CREATE PROCEDURE [dbo].[ReportExport_RequestComplete_UP]
@IdRequest int, 
@Status varchar(50), 
@URLPath varchar(500), 
@FileName varchar(250) 
AS 
BEGIN 
UPDATE ReportRequest WITH(ROWLOCK)
SET [Status] = @Status, Progress = 100, URLPath = @URLPath, [FileName] = @FileName 
WHERE IdRequest = @IdRequest
END