PRINT N'Creating [dbo].[GetCountryByIPnumber]...'; 

GO 

CREATE PROCEDURE [dbo].[GetCountryByIPnumber] @IpNumber BIGINT -- IP number from the IP address of the subscriber  
AS 
  BEGIN 
      SELECT TOP 1 c.IdCountry, 
                   c.Name, 
                   c.DialingCode 
      FROM   Blocks b WITH(NOLOCK) 
             INNER JOIN Location l WITH(NOLOCK) 
                     ON( b.LocId = l.LocId ) 
             INNER JOIN Country c WITH(NOLOCK) 
                     ON( l.Country = c.Code ) 
      WHERE  @IpNumber BETWEEN StartIpNum AND EndIpNum 
  END 

/*** SCRIPT TO UPDATE USERS WHO STARTED THE REGISTRATION USING OLD WORKFLOW AND WILL TRY FINISH USING THE NEW WORKFLOW ***/
GO 

PRINT N'Creating [getLongIP_Temp] function to convert ip to bigint...' 

GO 

CREATE FUNCTION [dbo].[getLongIP_Temp] (@ip NVARCHAR(MAX)) 
RETURNS BIGINT 
  BEGIN 
      DECLARE @start INT, 
              @end   INT, 
              @part  INT 
      DECLARE @result BIGINT 

      SELECT @start = 1, 
             @end = CHARINDEX('.', @ip), 
             @part = 1 

      SET @result = 0 

      WHILE @start < LEN(@ip) + 1 
        BEGIN 
            IF @end = 0 
              SET @end = LEN(@ip) + 1 

            IF @part = 1 
              SET @result = @result + CONVERT(BIGINT, SUBSTRING(@ip, @start, @end - @start)) * 16777216

            IF @part = 2 
              SET @result = @result + CONVERT(BIGINT, SUBSTRING(@ip, @start, @end - @start)) * 65536

            IF @part = 3 
              SET @result = @result + CONVERT(BIGINT, SUBSTRING(@ip, @start, @end - @start)) * 256

            IF @part = 4 
              SET @result = @result 
                            + CONVERT(BIGINT, SUBSTRING(@ip, @start, @end - @start)) 

            SET @start = @end + 1 
            SET @end = CHARINDEX('.', @ip, @start) 
            SET @part = @part + 1 
        END 

      RETURN @result 
  END 

GO 

PRINT N'Inserting (into temp table) the users with idState, and idUserTimeZone in null and converting its ip to bigint...'

GO 

DECLARE @temp_table TABLE 
  ( 
     idUser         INT, 
     registrationIp NVARCHAR(30), 
     longIp         BIGINT 
  ) 

INSERT INTO @temp_table 
            (idUser, 
             registrationIp, 
             longIp) 
SELECT u.IdUser, 
       u.registrationip, 
       dbo.getLongIP_Temp(ISNULL(u.RegistrationIp, '0.0.0.0')) 
FROM   [user] u 
WHERE  u.accountvalidation <> 1 
       AND ( u.idState IS NULL 
              OR u.idUserTimeZone IS NULL ) 

PRINT N'Updating idState (according register ip, Bs As by default) and idUserTimeZone (Buenos Aires, Georgetown) into [user] table...'

UPDATE u 
SET    IdUserTimeZone = 21, 
       IdState = ISNULL(b.IdState, 2189) 
FROM   [User] u WITH(ROWLOCK)
       INNER JOIN @temp_table tt 
               ON( u.IdUser = tt.idUser ) 
       OUTER APPLY (SELECT TOP 1 s.IdState 
                    FROM   Blocks b WITH(NOLOCK) 
                           INNER JOIN Location l WITH(NOLOCK) 
                                   ON( b.LocId = l.LocId ) 
                           INNER JOIN Country c WITH(NOLOCK) 
                                   ON( l.Country = c.Code ) 
                           INNER JOIN State s WITH(NOLOCK) 
                                   ON( s.IdCountry = s.IdCountry ) 
                    WHERE  ( tt.longIp BETWEEN StartIpNum AND EndIpNum )) b 
WHERE  u.accountvalidation <> 1 
       AND ( u.idState IS NULL 
              OR u.idUserTimeZone IS NULL ) 

-- Comment previous update and uncomment the bellow code in order to verify the update to be done
-- select * from @temp_table  
PRINT N'Droping [getLongIP_Temp] temporal function...' 

DROP FUNCTION [getLongIP_Temp] 
/*** END SCRIPT ***/ 