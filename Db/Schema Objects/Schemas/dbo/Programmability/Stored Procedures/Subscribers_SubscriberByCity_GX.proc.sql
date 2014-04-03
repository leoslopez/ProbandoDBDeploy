CREATE PROCEDURE [dbo].[Subscribers_SubscriberByCity_GX] @IdCampaign  INT, 
                                                        @CountryCode varchar(2), 
                                                        @City        varchar(50), 
                                                        @howmany     int 
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
             SUM(ISNULL(LT.Count, 0)) as CantClick 
      FROM   @t t 
             JOIN CampaignDeliveriesOpenInfo CDI WITH(NOLOCK) 
               on t.IdCampaign = cdi.IdCampaign 
             JOIN Location L WITH(NOLOCK) 
               ON CDI.LocId = L.LocId 
             JOIN Subscriber S WITH(NOLOCK) 
               ON CDI.IdSubscriber = S.IdSubscriber 
             LEFT JOIN Link Li WITH(NOLOCK) 
                    on t.IdCampaign = Li.IdCampaign 
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
      print( 'error en Subscribers_SubscriberByCity_GX' ) 
  END CATCH 

GO 