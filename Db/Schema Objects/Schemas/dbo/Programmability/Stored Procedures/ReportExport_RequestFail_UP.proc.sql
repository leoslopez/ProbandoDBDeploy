/****** Object:  StoredProcedure [dbo].[ReportExport_RequestFail_UP]    Script Date: 08/07/2013 11:37:11 ******/

CREATE PROCEDURE [dbo].[ReportExport_RequestFail_UP] 
@IdRequest int, 
@Status varchar(50),
@Progress int
AS 
BEGIN 
UPDATE ReportRequest WITH(ROWLOCK)
SET [Status] = @Status, Progress = @Progress 
WHERE IdRequest = @IdRequest 
END 