/****** Object:  StoredProcedure [dbo].[ReportExport_RequestRequeue_UP]    Script Date: 08/07/2013 11:37:30 ******/

CREATE PROCEDURE [dbo].[ReportExport_RequestRequeue_UP]
@IdRequest int,
@Status varchar(50),
@Language varchar(50)
AS
BEGIN
UPDATE ReportRequest WITH(ROWLOCK)
SET [Status] = @Status,
[Language] = @Language,
Progress = 0,
URLPath = NULL,
[FileName] = NULL,
[TimeStamp] = GetUTCDate(),
Active = 1
WHERE IdRequest = @IdRequest
END

GO