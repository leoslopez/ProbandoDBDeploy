CREATE PROCEDURE [dbo].[Subscribers_SubscriberByCampaignAndApertureDate_GX]
@IdCampaign INT,  
@Status INT,  
@Date DATETIME,  
@howmany int  
AS    
    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   Gettestabset(@IdCampaign) 

    DECLARE @offset INT 

    SELECT @offset = ISNULL(UTZ.Offset, 0) 
    FROM   Campaign C WITH(NOLOCK) 
           INNER JOIN [User] U WITH(NOLOCK) 
                   ON U.IdUser = C.IdUser 
           LEFT JOIN UserTimeZone UTZ WITH(NOLOCK) 
                  ON UTZ.IdUserTimeZone = U.IdUserTimeZone 
    WHERE  C.IdCampaign = @IdCampaign 

    SET ROWCOUNT @HowMany 

    SELECT S.Email, 
           S.FirstName, 
           S.LastName, 
           ISNULL(SUM(LT.Count), 0) as Clicks 
    FROM   @t t 
           JOIN CampaignDeliveriesOpenInfo CDI WITH(NOLOCK) 
             on t.IdCampaign = CDI.IdCampaign 
           LEFT JOIN Subscriber S WITH(NOLOCK) 
                  ON CDI.IdSubscriber = S.IdSubscriber 
           LEFT JOIN (SELECT LT.IdSubscriber, 
                             L.IdCampaign, 
                             LT.Count 
                      FROM   @t t 
                             JOIN Link L WITH(NOLOCK) 
                               on l.IdCampaign = t.IdCampaign 
                             JOIN LinkTracking LT WITH(NOLOCK) 
                                     ON L.IdLink = LT.IdLink) LT 
                  ON LT.IdSubscriber = S.IdSubscriber 
    WHERE  CDI.IdDeliveryStatus = 100 
           AND CONVERT(VARCHAR(10), DATEADD(minute, @offset, CDI.[Date]), 101) = CONVERT(VARCHAR(10), @Date, 101) 
    GROUP  BY S.Email, 
              S.FirstName, 
              S.LastName 
    ORDER  BY Clicks DESC 