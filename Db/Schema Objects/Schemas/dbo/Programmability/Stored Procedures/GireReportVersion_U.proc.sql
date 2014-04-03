
CREATE PROC [dbo].[GireReportVersion_U] (@DATE    AS DATETIME, 
                                         @VERSION INT) 
AS 
    DECLARE @COUNT INT 

    SET @COUNT = (SELECT count(*) 
                  FROM   GireReportVersion) 

    IF @COUNT = 0 
      BEGIN 
          INSERT INTO GireReportVersion 
          VALUES      (@DATE, 
                       @VERSION) 
      END 
    ELSE 
      BEGIN 
          UPDATE GireReportVersion 
          SET    Date = @DATE, 
                 Version = @VERSION 
      END