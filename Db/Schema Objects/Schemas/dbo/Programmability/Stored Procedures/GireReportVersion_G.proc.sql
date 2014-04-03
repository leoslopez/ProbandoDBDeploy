
CREATE PROC [dbo].[GireReportVersion_G] 
AS 
    SELECT TOP 1 [Date], 
                 [Version] 
    FROM   GireReportVersion