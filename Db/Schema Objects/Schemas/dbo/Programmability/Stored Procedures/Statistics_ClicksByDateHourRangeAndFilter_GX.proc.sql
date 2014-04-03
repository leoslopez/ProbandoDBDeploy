CREATE PROCEDURE [dbo].[Statistics_ClicksByDateHourRangeAndFilter_GX]
@IDCampaign INT, 
@StartDate DATETIME,  
@EndDate DATETIME,
@emailFilter varchar(50),
@firstnameFilter varchar(50),
@lastnameFilter varchar(50)  
AS  
    CREATE TABLE #DATERANGE 
      ( 
         [Date] varchar(10), 
         [Hour] INT 
      ) 

    DECLARE @Date DATETIME 
    DECLARE @offset INT 

    SELECT @offset = ISNULL(UTZ.Offset, 0) 
    FROM   Campaign C  WITH(NOLOCK) 
           INNER JOIN [User] U 
                   ON U.IdUser = C.IdUser 
           LEFT JOIN UserTimeZone UTZ 
                  ON UTZ.IdUserTimeZone = U.IdUserTimeZone 
    WHERE  C.IdCampaign = @IdCampaign 

    SET @StartDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), DATEADD(minute, @offset, @StartDate), 101))
    SET @EndDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), DATEADD(minute, @offset, @EndDate), 101))
    SET @Date = CONVERT(DATETIME, CONVERT(VARCHAR(10), @StartDate, 101)) 

    DECLARE @Hour INT 

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
           ISNULL(S.ClickCount, 0) as ClickCount 
    FROM   #DATERANGE DR 
           LEFT JOIN (SELECT CONVERT(VARCHAR(10), DATEADD(minute, @offset, LT.[Date]), 101) 
                             + ' ' 
                             + CONVERT(VARCHAR(10), DATEPART(HOUR, DATEADD(minute, @offset, LT.[Date])), 101) 
                             + ':00'       as ClickDate, 
                             SUM(LT.Count) as ClickCount 
                      FROM   @t t
                            JOIN Link L  WITH(NOLOCK) on t.IdCampaign = L.IdCampaign
							JOIN LinkTracking LT  WITH(NOLOCK) 
                                    ON LT.IdLink = L.IdLink 
                             JOIN Subscriber S  WITH(NOLOCK) 
                                    ON S.IdSubscriber = LT.IdSubscriber 
                      WHERE  ( S.Email like @emailFilter ) 
                             AND ISNULL(S.Firstname, '') like @firstnameFilter 
                             AND ISNULL(S.lastname, '') like @lastnameFilter 
                      GROUP  BY CONVERT(VARCHAR(10), DATEADD(minute, @offset, LT.[Date]), 101) 
                                + ' ' 
                                + CONVERT(VARCHAR(10), DATEPART(HOUR, DATEADD(minute, @offset, LT.[Date])), 101) 
                                + ':00') S 
                  ON CONVERT(VARCHAR(10), DR.[Date], 101) + ' ' 
                     + CONVERT(VARCHAR(2), DR.[Hour]) + ':00' = S.ClickDate 
    ORDER  BY CONVERT(datetime, DR.[Date], 101), 
              DR.[Hour] 