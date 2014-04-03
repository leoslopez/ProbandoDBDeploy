/****** Object:  StoredProcedure [dbo].[Statistics_ClicksByDateRange_GX]    Script Date: 08/07/2013 11:40:01 ******/


CREATE PROCEDURE [dbo].[Statistics_ClicksByDateRange_GX] @IDCampaign INT, 
                                                        @StartDate  DATETIME, 
                                                        @EndDate    DATETIME 
AS 
    CREATE TABLE #DATERANGE 
      ( 
         [Date] VARCHAR(10) 
      ) 

    DECLARE @Date DATETIME 
    DECLARE @offset INT 

    SELECT @offset = ISNULL(UTZ.Offset, 0) 
    FROM   Campaign C 
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
          INSERT INTO #DATERANGE 
          SELECT CONVERT(VARCHAR(10), @Date, 101) 

          SET @Date = DATEADD(dd, 1, @Date) 
      END 

    SELECT CONVERT(VARCHAR(10), DR.[Date], 101), 
           SUM(ISNULL(LT.Count, 0)) ClickCount 
    FROM   dbo.LinkTracking LT WITH(NOLOCK) 
           RIGHT JOIN #DATERANGE DR 
                   ON CONVERT(VARCHAR(10), DATEADD(minute, @offset, LT.[Date]), 101) = CONVERT(VARCHAR(10), DR.[Date], 101) 
           LEFT OUTER JOIN Link L WITH(NOLOCK) 
                        ON LT.IdLink = L.IdLink 
    WHERE  L.IdCampaign = @IDCampaign 
    GROUP  BY CONVERT(VARCHAR(10), DR.[Date], 101) 
    ORDER  BY CONVERT(VARCHAR(10), DR.[Date], 101) DESC 