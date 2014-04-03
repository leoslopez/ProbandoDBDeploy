

CREATE PROCEDURE [dbo].[BlackListDomainAdded] 
AS 
    DECLARE @Domains TABLE 
      ( 
         Domain VARCHAR(200) 
      ) 

    INSERT INTO @Domains 
                (Domain) 
    SELECT Domain 
    FROM   dbo.BlackListDomain 
    WHERE  IsInListProcess = 0 

    UPDATE dbo.BlackListDomain 
    SET    IsInListProcess = 1 
    FROM   dbo.BlackListDomain bld 
           JOIN @Domains d 
             ON bld.Domain = d.Domain 

    SELECT Domain 
    FROM   @Domains 