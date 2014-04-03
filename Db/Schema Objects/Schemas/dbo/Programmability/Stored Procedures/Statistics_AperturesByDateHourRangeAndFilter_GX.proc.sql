
CREATE PROCEDURE [dbo].[Statistics_AperturesByDateHourRangeAndFilter_GX] @IdCampaign      INT,
                                                                        @StartDate       DATETIME,
                                                                        @EndDate         DATETIME,
                                                                        @Status          INT,
                                                                        @emailFilter     VARCHAR(50),
                                                                        @firstnameFilter VARCHAR(50),
                                                                        @lastnameFilter  VARCHAR(50)
AS 
    DECLARE @offset INT 

    SELECT @offset = ISNULL(UTZ.Offset, 0) 
    FROM   Campaign C WITH(NOLOCK)
           INNER JOIN [User] U WITH(NOLOCK)
                   ON U.IdUser = C.IdUser 
           LEFT JOIN UserTimeZone UTZ WITH(NOLOCK)
                  ON UTZ.IdUserTimeZone = U.IdUserTimeZone 
    WHERE  C.IdCampaign = @IdCampaign 

    --StartDate is StartDate's date at 00:00:00   
    SET @StartDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), DATEADD(minute, @offset, @StartDate), 101))
    --EndDate is EndDate's date at 00:00:00   
    SET @EndDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), DATEADD(minute, @offset, @EndDate), 101))

    DECLARE @Date DATETIME 

    SET @Date = CONVERT(DATETIME, CONVERT(VARCHAR(10), @StartDate, 101)) 

    DECLARE @Hour INT 

    CREATE TABLE #DATERANGE 
      ( 
         [Date] VARCHAR(10), 
         [Hour] INT 
      ) 

    WHILE ( @Date <= @EndDate ) 
      BEGIN 
          SET @Hour = 0 

          WHILE ( @Hour <= 23 ) 
            BEGIN 
                INSERT INTO #DATERANGE 
                SELECT CONVERT(VARCHAR(10), @Date, 101) [Date], 
                       @Hour                            [Hour] 

                SET @Hour = @Hour + 1 
            END 

          SET @Date = DATEADD(dd, 1, @Date) 
      END 

    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   GetTestABSet(@IdCampaign) 

    SELECT CONVERT(VARCHAR(10), DR.[Date], 101) + ' ' 
           + CONVERT(VARCHAR(2), DR.[Hour]) + ':00', 
           ISNULL(SUM(C.Count), 0) 
    FROM   #DATERANGE DR 
           LEFT JOIN (SELECT cd.Count, 
                             cd.Date, 
                             cd.IdCampaign, 
                             cd.IdSubscriber 
                      FROM   CampaignDeliveriesOpenInfo cd WITH(NOLOCK) 
                             JOIN @t t 
                               ON cd.IdCampaign = t.IdCampaign 
                      WHERE  IdDeliveryStatus = 100) C 
                  ON CONVERT(VARCHAR(10), DR.[Date], 101) = CONVERT(VARCHAR(10), DATEADD(minute, @offset, C.[Date]), 101) 
                     AND DATEPART(hh, DATEADD(minute, @offset, C.[Date])) = DR.[Hour] 
           LEFT JOIN Subscriber S WITH(NOLOCK, INDEX(PK_Suscriber)) 
                  ON C.IdSubscriber = S.IdSubscriber 
    WHERE  ( S.Email LIKE @emailFilter ) 
           AND ISNULL(S.Firstname, '') LIKE @firstnameFilter 
           AND ISNULL(S.lastname, '') LIKE @lastnameFilter 
    GROUP  BY CONVERT(VARCHAR(10), DR.[Date], 101), 
              DR.[Hour] 
    ORDER  BY CONVERT(DATETIME, DR.[Date]), 
              DR.[Hour] 