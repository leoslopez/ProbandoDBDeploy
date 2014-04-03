/****** Object:  StoredProcedure [dbo].[ReportExport_RequestProgress_UP]    Script Date: 08/07/2013 11:37:24 ******/

CREATE PROCEDURE [dbo].[ReportExport_RequestProgress_UP]
@IdRequest int,    
@Status varchar(50),    
@Progress int    
AS    
BEGIN      
  UPDATE ReportRequest WITH(ROWLOCK)  
  SET [Status] = @Status, Progress = @Progress   
  WHERE IdRequest = @IdRequest
END    
GO