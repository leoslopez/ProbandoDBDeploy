
CREATE PROCEDURE [dbo].[Statistics_TotalAperturesByCampaignAndFilter_GX] @IdCampaign      INT,
                                                                        @StatusID        INT,
                                                                        @emailFilter     VARCHAR(50),
                                                                        @firstnameFilter VARCHAR(50),
                                                                        @lastnameFilter  VARCHAR(50)
AS 
    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   Gettestabset(@IdCampaign) 

    DECLARE @timeZoneOffset INT 

    SELECT @timeZoneOffset = ISNULL(UTZ.Offset, 0) 
    FROM   Campaign C WITH(NOLOCK) 
           JOIN [User] U WITH(NOLOCK) 
             ON U.IdUser = C.IdUser 
           LEFT JOIN UserTimeZone UTZ WITH(NOLOCK) 
                  ON U.IdUserTimeZone = UTZ.IdUserTimeZone 
    WHERE  IdCampaign = @IdCampaign 

    SELECT CONVERT(VARCHAR(10), DATEADD(minute, @timeZoneOffset, CDI.[Date]), 101), 
           COUNT(ISNULL(CDI.Count, 1)) OpenCount 
    FROM   @t t 
           JOIN CampaignDeliveriesOpenInfo CDI WITH(NOLOCK, INDEX(IX_CampaignDeliveries_IdCampaignApertures))
             ON cdi.IdCampaign = t.IdCampaign 
           JOIN Subscriber S WITH(NOLOCK, INDEX(PK_Suscriber)) 
             ON CDI.IdSubscriber = S.IdSubscriber 
    WHERE  CDI.IdDeliveryStatus = 100 
           AND ( S.email LIKE @emailFilter ) 
           AND ( S.Firstname LIKE @firstnameFilter 
                  OR S.FirstName IS NULL ) 
           AND ( S.lastname LIKE @lastnameFilter 
                  OR S.LastName IS NULL ) 
    GROUP  BY CONVERT(VARCHAR(10), DATEADD(minute, @timeZoneOffset, CDI.[Date]), 101) 
    ORDER  BY CONVERT(VARCHAR(10), DATEADD(minute, @timeZoneOffset, CDI.[Date]), 101) DESC 