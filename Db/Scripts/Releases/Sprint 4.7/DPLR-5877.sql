﻿-- =============================================
-- Script Template
-- =============================================
CREATE FUNCTION [dbo].[FormatDateByLanguage]
(
 @language INT,
 @date datetime
)
RETURNS varchar(MAX)
AS
BEGIN

   IF(@date IS NULL OR @date = '' OR ISDATE(@date) != 1) return null
   
   if (@language = 1)--Spanish
	 return Convert(varchar, @date,103)

   if (@language = 2)--English
	 return Convert(varchar, @date,101)

 return Convert(varchar, @date,101)
END

GO


ALTER PROCEDURE [dbo].[Campaigns_GetSubscribersAndCustoms_NOT_Hotmail] @IDCampaign INT, 
                                                                       @Amount     INT = 0 
AS 
    DECLARE @t TABLE 
      ( 
         idsubscriber BIGINT, 
         dtype        BIT, 
         id           BIGINT, 
         firstname    NVARCHAR(200), 
         lastname     NVARCHAR(200), 
         email        NVARCHAR(400), 
         iduser       INT, 
         lang         INT, 
         UNIQUE CLUSTERED ( idsubscriber, dtype, id) 
      ) 

    IF ( @Amount > 0 ) 
      BEGIN 
          IF( EXISTS (SELECT TOP 1 cdoi.IdSubscriber 
                      FROM   dbo.CampaignDeliveriesOpenInfo cdoi 
                      WHERE  cdoi.IdCampaign = @IDCampaign) ) 
            BEGIN 
                INSERT INTO @t 
                SELECT TOP (@Amount) s.idsubscriber, 
                                     0              t, 
                                     s.IdSubscriber AS ID, 
                                     s.FirstName, 
                                     s.LastName, 
                                     s.Email, 
                                     s.IDUser, 
                                     0              AS lang 
                FROM   SubscribersListXCampaign SLxC WITH (NOLOCK) 
                       JOIN dbo.SubscribersList SL WITH (NOLOCK) 
                         ON SLxC.IdSubscribersList = SL.IdSubscribersList 
                       JOIN SubscriberxList SxL WITH (NOLOCK) 
                         ON SL.IdSubscribersList = SXL.IdSubscribersList 
                       JOIN Subscriber s WITH (NOLOCK) 
                         ON s.IdSubscriber = SxL.IdSubscriber 
                       JOIN CampaignXSubscriberStatus cdoi WITH(NOLOCK) 
                         ON s.IdSubscriber = cdoi.IdSubscriber 
                            AND cdoi.IdCampaign = @IDCampaign 
                            AND cdoi.Sent = 0 
                WHERE  ( SLxC.IdCampaign = @IDCampaign ) 
                       AND ( SL.Active = 1 ) 
                       AND ( SxL.Active = 1 ) 
                       AND ( s.IdSubscribersStatus < 3 ) 
                       AND ( s.email NOT LIKE '%@hotmail%' ) 
                       AND ( s.email NOT LIKE '%@msn%' ) 
                       AND ( s.email NOT LIKE '%@live%' ) 
                       AND ( s.email NOT LIKE '%@outlook%' ) 
                GROUP  BY s.IdSubscriber, 
                          s.FirstName, 
                          s.LastName, 
                          s.Email, 
                          s.IdUser 
            END 
          ELSE 
            BEGIN 
                INSERT INTO @t 
                SELECT TOP (@Amount) s.idsubscriber, 
                                     0              t, 
                                     s.IdSubscriber AS ID, 
                                     s.FirstName, 
                                     s.LastName, 
                                     s.Email, 
                                     s.IDUser, 
                                     0              AS lang 
                FROM   SubscribersListXCampaign SLxC WITH (NOLOCK) 
                       JOIN dbo.SubscribersList SL WITH (NOLOCK) 
                         ON SLxC.IdSubscribersList = SL.IdSubscribersList 
                       JOIN SubscriberxList SxL WITH (NOLOCK) 
                         ON SL.IdSubscribersList = SXL.IdSubscribersList 
                       JOIN Subscriber s WITH (NOLOCK) 
                         ON s.IdSubscriber = SxL.IdSubscriber 
                WHERE  ( SLxC.IdCampaign = @IDCampaign ) 
                       AND ( SL.Active = 1 ) 
                       AND ( SxL.Active = 1 ) 
                       AND ( s.IdSubscribersStatus < 3 ) 
                       AND ( s.email NOT LIKE '%@hotmail%' ) 
                       AND ( s.email NOT LIKE '%@msn%' ) 
                       AND ( s.email NOT LIKE '%@live%' ) 
                       AND ( s.email NOT LIKE '%@outlook%' ) 
                GROUP  BY s.IdSubscriber, 
                          s.FirstName, 
                          s.LastName, 
                          s.Email, 
                          s.IdUser 
            END 
      END 
    ELSE 
      BEGIN 
          INSERT INTO @t 
          SELECT DISTINCT s.idsubscriber, 
                          0              t, 
                          s.IdSubscriber AS ID, 
                          s.FirstName, 
                          s.LastName, 
                          s.Email, 
                          s.IDUser, 
                          0              AS lang 
          FROM   SubscribersListXCampaign SLxC WITH (NOLOCK) 
                 JOIN dbo.SubscribersList SL WITH (NOLOCK) 
                   ON SLxC.IdSubscribersList = SL.IdSubscribersList 
                 JOIN SubscriberxList SxL WITH (NOLOCK) 
                   ON SL.IdSubscribersList = SXL.IdSubscribersList 
                 JOIN Subscriber s WITH (NOLOCK) 
                   ON s.IdSubscriber = SxL.IdSubscriber 
          WHERE  ( SLxC.IdCampaign = @IDCampaign ) 
                 AND ( SL.Active = 1 ) 
                 AND ( SxL.Active = 1 ) 
                 AND ( s.IdSubscribersStatus < 3 ) 
                 AND ( s.email NOT LIKE '%@hotmail%' ) 
                 AND ( s.email NOT LIKE '%@msn%' ) 
                 AND ( s.email NOT LIKE '%@live%' ) 
                 AND ( s.email NOT LIKE '%@outlook%' ) 
      END 
      
    DECLARE @language INT
    SET @language = (SELECT u.IdLanguage FROM [User] u WITH(NOLOCK) WHERE u.IdUser 
               IN(SELECT IdUser from [Campaign] C WITH(NOLOCK) WHERE IdCampaign = @IDCampaign)) 

    INSERT INTO @t 
    SELECT DISTINCT t.idsubscriber, 
                    1, 
                    319         AS ID, 
                    319         AS FirstName, 
                    319         AS LastName, 
                    s.FirstName AS Email, 
                    t.IdUser, 
                    0           AS lang 
    FROM   Subscriber s 
           JOIN @t t 
             ON t.idsubscriber = s.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT t.idsubscriber, 
                    1, 
                    320        AS ID, 
                    320        AS FirstName, 
                    320        AS LastName, 
                    s.LastName AS Email, 
                    t.IdUser, 
                    0          AS lang 
    FROM   Subscriber s 
           JOIN @t t 
             ON t.idsubscriber = s.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT t.idsubscriber, 
                    1, 
                    321     AS ID, 
                    321     AS FirstName, 
                    321     AS LastName, 
                    s.Email AS Email, 
                    t.IdUser, 
                    0       AS lang 
    FROM   Subscriber s 
           JOIN @t t 
             ON t.idsubscriber = s.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT t.idsubscriber, 
                    1, 
                    322      AS ID, 
                    322      AS FirstName, 
                    322      AS LastName, 
                    s.Gender AS Email, 
                    t.IdUser, 
                    0        AS lang 
    FROM   Subscriber s 
           JOIN @t t 
             ON t.idsubscriber = s.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT t.idsubscriber, 
                    1, 
                    324    AS ID, 
                    324    AS FirstName, 
                    324    AS LastName, 
                    c.Name AS Email, 
                    t.IdUser, 
                    0      AS lang 
    FROM   Subscriber s 
           LEFT JOIN Country c 
                  ON s.IdCountry = c.IdCountry 
           JOIN @t t 
             ON t.idsubscriber = s.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT t.idsubscriber, 
                    1, 
                    323           AS ID, 
                    323           AS FirstName, 
                    323           AS LastName,
                    --s.UTCBirthday as Email,
					dbo.FormatDateByLanguage(@language, s.UTCBirthday) AS Email,
                    t.IdUser, 
                    0             AS lang 
    FROM   Subscriber s 
           JOIN @t t 
             ON t.idsubscriber = s.IdSubscriber 
   
    INSERT INTO @t 
    SELECT DISTINCT t.idsubscriber, 
                    1, 
                    f.IdField AS ID, 
                    f.IdField AS FirstName, 
                    f.IdField AS LastName,
                    CASE f.DataType  
                        WHEN 3 THEN   --DATETIME type   
                           CASE 
                               WHEN ISDATE(FxS.Value) = 1 THEN dbo.FormatDateByLanguage(@language,  CONVERT(datetime,FxS.Value))
                               ELSE NULL                  
                           END
                 	    ELSE FxS.Value
                    END AS Email, 
                    t.IdUser, 
                    0         AS lang 
    FROM   ContentXField CxF WITH(NOLOCK) 
           JOIN Field f WITH(NOLOCK) 
             ON f.IdField = CxF.IdField 
           JOIN @t t 
             ON t.iduser = f.IdUser 
                AND t.dtype = 0 
           JOIN [User] u WITH(NOLOCK) ON u.IdUser = t.iduser
           LEFT JOIN FieldXSubscriber FxS WITH(NOLOCK) 
                  ON FxS.IdField = CxF.IdField 
                     AND t.idsubscriber = FxS.IdSubscriber 
    WHERE  CxF.IdContent = @IDCampaign 

    -- Clients Gire guardamos Field uzado en la campaign            
    IF EXISTS(SELECT 1 
              FROM   Campaign WITH(ROWLOCK) 
              WHERE  IdCampaign = @IdCampaign 
                     AND IdUser IN ( 17373, 12790 )) 
      BEGIN 
          INSERT INTO [CampaignFieldUsed] WITH(ROWLOCK) 
                      (IdCampaign, 
                       IdSubscriber, 
                       IdField, 
                       Value) 
          SELECT @IDCampaign, 
                 t.idsubscriber, 
                 t.id, 
                 t.email 
          FROM   @t t 
				JOIN dbo.ContentXField cxf on cxf.IdField = t.id
		  WHERE t.email IS NOT NULL
				AND cxf.IdContent = @IDCampaign
      END 

    SELECT dtype, 
           id, 
           firstname, 
           lastname, 
           email, 
           iduser, 
           lang 
    FROM   @t 
    ORDER  BY idsubscriber, 
              dtype, 
              id
GO

ALTER PROCEDURE [dbo].[Campaigns_GetSubscribersAndCustoms_Hotmail] @IDCampaign INT, 
                                                                   @Amount     INT = 0 
AS 
    DECLARE @t TABLE 
      ( 
         idsubscriber BIGINT, 
         dtype        BIT, 
         id           BIGINT, 
         firstname    NVARCHAR(200), 
         lastname     NVARCHAR(200), 
         email        NVARCHAR(400), 
         iduser       INT, 
         lang         INT, 
         UNIQUE CLUSTERED ( idsubscriber, dtype, id) 
      ) 

    IF ( @Amount > 0 ) 
      BEGIN 
          IF( EXISTS (SELECT TOP 1 cdoi.IdSubscriber 
                      FROM   dbo.CampaignDeliveriesOpenInfo cdoi 
                      WHERE  cdoi.IdCampaign = @IDCampaign) ) 
            BEGIN 
                INSERT INTO @t 
                SELECT TOP (@Amount) S.idsubscriber, 
                                     0              t, 
                                     S.IdSubscriber AS ID, 
                                     S.FirstName, 
                                     S.LastName, 
                                     S.Email, 
                                     S.IDUser, 
                                     0              AS LANG 
                FROM   SubscribersListXCampaign SLXC WITH (NOLOCK) 
                       JOIN dbo.SubscribersList SL WITH (NOLOCK) 
                         ON SLXC.IdSubscribersList = SL.IdSubscribersList 
                       JOIN SubscriberxList SXL WITH (NOLOCK) 
                         ON SL.IdSubscribersList = SXL.IdSubscribersList 
                       JOIN Subscriber S WITH (NOLOCK) 
                         ON S.IdSubscriber = SXL.IdSubscriber 
                       JOIN CampaignXSubscriberStatus cdoi WITH(NOLOCK) 
                         ON s.IdSubscriber = cdoi.IdSubscriber 
                            AND cdoi.IdCampaign = @IDCampaign 
                            AND cdoi.Sent = 0 
                WHERE  ( SLXC.IdCampaign = @IDCampaign ) 
                       AND ( SL.Active = 1 ) 
                       AND ( SXL.Active = 1 ) 
                       AND ( S.IdSubscribersStatus < 3 ) 
                       AND ( ( S.email LIKE '%@hotmail%' ) 
                              OR ( S.email LIKE '%@msn%' ) 
                              OR ( S.email LIKE '%@live%' ) 
                              OR ( S.email LIKE '%@outlook%' ) ) 
                GROUP  BY s.IdSubscriber, 
                          s.FirstName, 
                          s.LastName, 
                          s.Email, 
                          s.IdUser 
            END 
          ELSE 
            BEGIN 
                INSERT INTO @t 
                SELECT TOP (@Amount) S.idsubscriber, 
                                     0              t, 
                                     S.IdSubscriber AS ID, 
                                     S.FirstName, 
                                     S.LastName, 
                                     S.Email, 
                                     S.IDUser, 
                                     0              AS LANG 
                FROM   SubscribersListXCampaign SLXC WITH (NOLOCK) 
                       JOIN dbo.SubscribersList SL WITH (NOLOCK) 
                         ON SLXC.IdSubscribersList = SL.IdSubscribersList 
                       JOIN SubscriberxList SXL WITH (NOLOCK) 
                         ON SL.IdSubscribersList = SXL.IdSubscribersList 
                       JOIN Subscriber S WITH (NOLOCK) 
                         ON S.IdSubscriber = SXL.IdSubscriber 
                WHERE  ( SLXC.IdCampaign = @IDCampaign ) 
                       AND ( SL.Active = 1 ) 
                       AND ( SXL.Active = 1 ) 
                       AND ( S.IdSubscribersStatus < 3 ) 
                       AND ( ( S.email LIKE '%@hotmail%' ) 
                              OR ( S.email LIKE '%@msn%' ) 
                              OR ( S.email LIKE '%@live%' ) 
                              OR ( S.email LIKE '%@outlook%' ) ) 
                GROUP  BY s.IdSubscriber, 
                          s.FirstName, 
                          s.LastName, 
                          s.Email, 
                          s.IdUser 
            END 
      END 
    ELSE 
      BEGIN 
          INSERT INTO @t 
          SELECT DISTINCT S.idsubscriber, 
                          0              t, 
                          S.IdSubscriber AS ID, 
                          S.FirstName, 
                          S.LastName, 
                          S.Email, 
                          S.IDUser, 
                          0              AS LANG 
          FROM   SubscribersListXCampaign SLXC WITH (NOLOCK) 
                 JOIN dbo.SubscribersList SL WITH (NOLOCK) 
                   ON SLXC.IdSubscribersList = SL.IdSubscribersList 
                 JOIN SubscriberxList SXL WITH (NOLOCK) 
                   ON SL.IdSubscribersList = SXL.IdSubscribersList 
                 JOIN Subscriber S WITH (NOLOCK) 
                   ON S.IdSubscriber = SXL.IdSubscriber 
          WHERE  ( SLXC.IdCampaign = @IDCampaign ) 
                 AND ( SL.Active = 1 ) 
                 AND ( SXL.Active = 1 ) 
                 AND ( S.IdSubscribersStatus < 3 ) 
                 AND ( ( S.email LIKE '%@hotmail%' ) 
                        OR ( S.email LIKE '%@msn%' ) 
                        OR ( S.email LIKE '%@live%' ) 
                        OR ( S.email LIKE '%@outlook%' ) ) 
      END 
     
    DECLARE @language INT
    SET @language = (SELECT u.IdLanguage FROM [User] u WITH(NOLOCK) WHERE u.IdUser 
               IN(SELECT IdUser from [Campaign] C WITH(NOLOCK) WHERE IdCampaign = @IDCampaign)) 
  

    INSERT INTO @t 
    SELECT DISTINCT T.idsubscriber, 
                    1, 
                    319         AS ID, 
                    319         AS FIRSTNAME, 
                    319         AS LASTNAME, 
                    S.FirstName AS EMAIL, 
                    T.IdUser, 
                    0           AS LANG 
    FROM   Subscriber S 
           JOIN @t T 
             ON T.idsubscriber = S.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT T.idsubscriber, 
                    1, 
                    320        AS ID, 
                    320        AS FIRSTNAME, 
                    320        AS LASTNAME, 
                    S.LastName AS EMAIL, 
                    T.IdUser, 
                    0          AS LANG 
    FROM   Subscriber S 
           JOIN @t T 
             ON T.idsubscriber = S.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT T.idsubscriber, 
                    1, 
                    321     AS ID, 
                    321     AS FIRSTNAME, 
                    321     AS LASTNAME, 
                    S.Email AS EMAIL, 
                    T.IdUser, 
                    0       AS LANG 
    FROM   Subscriber S 
           JOIN @t T 
             ON T.idsubscriber = S.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT T.idsubscriber, 
                    1, 
                    322      AS ID, 
                    322      AS FIRSTNAME, 
                    322      AS LASTNAME, 
                    S.Gender AS EMAIL, 
                    T.IdUser, 
                    0        AS LANG 
    FROM   Subscriber S 
           JOIN @t T 
             ON T.idsubscriber = S.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT T.idsubscriber, 
                    1, 
                    324    AS ID, 
                    324    AS FIRSTNAME, 
                    324    AS LASTNAME, 
                    C.Name AS EMAIL, 
                    T.IdUser, 
                    0      AS LANG 
    FROM   Subscriber S 
           LEFT JOIN Country C 
                  ON S.IdCountry = C.IdCountry 
           JOIN @t T 
             ON T.idsubscriber = S.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT T.idsubscriber, 
                    1, 
                    323           AS ID, 
                    323           AS FIRSTNAME, 
                    323           AS LASTNAME, 
           		    dbo.FormatDateByLanguage(@language,  s.UTCBirthday) AS Email,
                    T.IdUser, 
                    0             AS LANG 
    FROM   Subscriber S 
           JOIN @t T 
             ON T.idsubscriber = S.IdSubscriber 
    INSERT INTO @t 
    SELECT DISTINCT T.idsubscriber, 
                    1, 
                    F.IdField AS ID, 
                    F.IdField AS FIRSTNAME, 
                    F.IdField AS LASTNAME, 
                    CASE F.DataType  
                        WHEN 3 THEN   --DATETIME type   
                           CASE 
                               WHEN ISDATE(FXS.Value) = 1 THEN dbo.FormatDateByLanguage(@language,  CONVERT(datetime,FXS.Value))
                               ELSE NULL                  
                           END
                 	    ELSE FXS.Value
                    END AS Email, 
                    T.IdUser, 
                    0         AS LANG 
    FROM   ContentXField CXF WITH(NOLOCK) 
           JOIN Field F WITH(NOLOCK) 
             ON F.IdField = CXF.IdField 
           JOIN @t T 
             ON T.iduser = F.IdUser 
                AND T.dtype = 0 
		   JOIN [User] u WITH(NOLOCK) ON u.IdUser = T.iduser
           LEFT JOIN FieldXSubscriber FXS WITH(NOLOCK) 
                  ON FXS.IdField = CXF.IdField 
                     AND T.idsubscriber = FXS.IdSubscriber 
    WHERE  CXF.IdContent = @IDCampaign 

    -- Clients Gire guardamos Field uzado en la campaign             
    IF EXISTS(SELECT 1 
              FROM   Campaign WITH(ROWLOCK) 
              WHERE  IdCampaign = @IdCampaign 
                     AND IdUser IN ( 17373, 12790 )) 
      BEGIN 
          INSERT INTO [CampaignFieldUsed] WITH(ROWLOCK) 
                      (IdCampaign, 
                       IdSubscriber, 
                       IdField, 
                       Value) 
          SELECT @IDCampaign, 
                 t.idsubscriber, 
                 t.id, 
                 t.email 
          FROM   @t t 
				JOIN dbo.ContentXField cxf on cxf.IdField = t.id
		  WHERE t.email IS NOT NULL
				AND cxf.IdContent = @IDCampaign     
	 END 

    SELECT dtype, 
           id, 
           firstname, 
           lastname, 
           email, 
           iduser, 
           lang 
    FROM   @t 
    ORDER  BY idsubscriber, 
              dtype, 
              id 
