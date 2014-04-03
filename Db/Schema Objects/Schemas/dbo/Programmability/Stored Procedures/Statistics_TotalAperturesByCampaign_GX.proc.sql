CREATE PROCEDURE [dbo].[Statistics_TotalAperturesByCampaign_GX] @IdCampaign INT, 
                                                                @StatusID   INT 
AS 
    DECLARE @t TABLE 
      ( 
         idcampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT idcampaign 
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
           JOIN CampaignDeliveriesOpenInfo cdi WITH(NOLOCK) 
             on cdi.IdCampaign = t.IdCampaign 
    WHERE  CDI.IdDeliveryStatus = 100 
    GROUP  BY CONVERT(VARCHAR(10), DATEADD(minute, @timeZoneOffset, CDI.[Date]), 101) 
    ORDER  BY CONVERT(VARCHAR(10), DATEADD(minute, @timeZoneOffset, CDI.[Date]), 101) DESC 