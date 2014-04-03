ALTER PROCEDURE [dbo].[Subscribers_SubscriberByCityAndFilter_GX] @IdCampaign      INT, 
                                                                 @CountryCode     VARCHAR(2),
                                                                 @City            VARCHAR(50),
                                                                 @emailFilter     VARCHAR(50),
                                                                 @firstnameFilter VARCHAR(50),
                                                                 @lastnameFilter  VARCHAR(50),
                                                                 @howmany         INT 
AS 
    SET NOCOUNT ON 

  BEGIN TRY 
      DECLARE @t TABLE 
        ( 
           IdCampaign INT PRIMARY KEY 
        ); 

      INSERT INTO @t 
      SELECT IdCampaign 
      FROM   Gettestabset(@IdCampaign) 

      SET ROWCOUNT @HowMany 

      SELECT S.Email, 
             S.FirstName, 
             S.LastName, 
             SUM(ISNULL(LT.Count, 0)) AS CantClick 
      FROM   @t t 
             JOIN CampaignDeliveriesOpenInfo CDI WITH(NOLOCK) 
               ON t.IdCampaign = cdi.IdCampaign 
             JOIN Location L WITH(NOLOCK) 
               ON CDI.LocId = L.LocId 
             JOIN Subscriber S WITH(NOLOCK) 
               ON CDI.IdSubscriber = S.IdSubscriber 
             LEFT JOIN Link Li WITH(NOLOCK) 
                    ON t.IdCampaign = Li.IdCampaign 
             LEFT JOIN LinkTracking LT WITH(NOLOCK) 
                    ON Li.IdLink = LT.IdLink 
                       AND CDI.IdSubscriber = LT.IdSubscriber 
      WHERE  L.City = @City 
             AND L.Country = @CountryCode 
             AND s.email LIKE @emailFilter 
             AND ISNULL(s.Firstname, '') LIKE @firstnameFilter 
             AND ISNULL(s.lastname, '') LIKE @lastnameFilter 
      GROUP  BY S.Email, 
                S.FirstName, 
                S.LastName 
      ORDER  BY CantClick DESC 
  END TRY 

  BEGIN CATCH 
      PRINT( 'error en Subscribers_SubscriberByCityAndFilter_GX' ) 
  END CATCH 

GO 

ALTER PROCEDURE [dbo].[Subscribers_SubscriberByCity_GX] @IdCampaign  INT, 
                                                        @CountryCode VARCHAR(2), 
                                                        @City        VARCHAR(50), 
                                                        @howmany     INT 
AS 
    SET NOCOUNT ON 

  BEGIN TRY 
      DECLARE @t TABLE 
        ( 
           IdCampaign INT PRIMARY KEY 
        ); 

      INSERT INTO @t 
      SELECT IdCampaign 
      FROM   Gettestabset(@IdCampaign) 

      SET ROWCOUNT @HowMany 

      SELECT S.Email, 
             S.FirstName, 
             S.LastName, 
             SUM(ISNULL(LT.Count, 0)) AS CantClick 
      FROM   @t t 
             JOIN CampaignDeliveriesOpenInfo CDI WITH(NOLOCK) 
               ON t.IdCampaign = cdi.IdCampaign 
             JOIN Location L WITH(NOLOCK) 
               ON CDI.LocId = L.LocId 
             JOIN Subscriber S WITH(NOLOCK) 
               ON CDI.IdSubscriber = S.IdSubscriber 
             LEFT JOIN Link Li WITH(NOLOCK) 
                    ON t.IdCampaign = Li.IdCampaign 
             LEFT JOIN LinkTracking LT WITH(NOLOCK) 
                    ON Li.IdLink = LT.IdLink 
                       AND CDI.IdSubscriber = LT.IdSubscriber 
      WHERE  L.City = @City 
             AND L.Country = @CountryCode 
      GROUP  BY S.Email, 
                S.FirstName, 
                S.LastName 
      ORDER  BY CantClick DESC 
  END TRY 

  BEGIN CATCH 
      PRINT( 'error en Subscribers_SubscriberByCity_GX' ) 
  END CATCH 

GO 