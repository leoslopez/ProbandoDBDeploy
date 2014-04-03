/****** Object:  StoredProcedure [dbo].[ReportExport_Request_D]    Script Date: 08/07/2013 11:36:25 ******/

CREATE PROCEDURE [dbo].[ReportExport_Request_D]
@IdRequest int    
AS    
BEGIN    
  UPDATE ReportRequest WITH(ROWLOCK)  
  SET Active = 0   
  WHERE IdRequest = @IdRequest    
END      
GO