
CREATE PROCEDURE [dbo].[BlackListEmailAdded] 
AS 
    DECLARE @Emails TABLE 
      ( 
         Email VARCHAR(200) 
      ) 

    INSERT INTO @Emails 
                (Email) 
    SELECT Email 
    FROM   dbo.BlackListEmail 
    WHERE  IsInListProcess = 0 

    UPDATE dbo.BlackListEmail 
    SET    IsInListProcess = 1 
    FROM   dbo.BlackListEmail bld 
           JOIN @Emails d 
             ON bld.Email = d.Email 

    SELECT Email 
    FROM   @Emails 