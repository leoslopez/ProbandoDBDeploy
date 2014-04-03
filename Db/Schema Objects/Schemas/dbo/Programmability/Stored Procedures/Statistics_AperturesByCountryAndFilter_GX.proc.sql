CREATE PROCEDURE [dbo].[Statistics_AperturesByCountryAndFilter_GX] @IdCampaign      INT, 
                                                                   @StartDate       DATETIME,
                                                                   @EndDate         DATETIME,
                                                                   @emailFilter     varchar(50),
                                                                   @firstnameFilter varchar(50),
                                                                   @lastnameFilter  varchar(50)
AS 
    SET @StartDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), @StartDate, 101), 101) 
    SET @EndDate = DATEADD(dd, 1, @EndDate) 
    SET @EndDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), @EndDate, 101), 101) 

    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   GetTestABSet(@IdCampaign) 

    SELECT CO.Name, 
           CO.Code, 
           SUM(cdoi.Count)             CantOpen, 
           SUM(ISNULL(C.CantClick, 0)) AS CantClick 
    FROM   @t t 
           JOIN CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
             ON cdoi.IdCampaign = t.IdCampaign 
                AND IdDeliveryStatus = 100 
                AND cdoi.Date BETWEEN @StartDate AND @EndDate 
           JOIN dbo.Location L WITH(NOLOCK) 
             ON cdoi.LocId = L.LocId 
           JOIN Country CO WITH(NOLOCK) 
             ON CO.Code = L.Country 
           LEFT JOIN (SELECT LT.IdSubscriber, 
                             L.IdCampaign, 
                             SUM(LT.Count) AS CantClick 
                      FROM   LinkTracking LT  WITH(NOLOCK) 
                             INNER JOIN Link L  WITH(NOLOCK) 
                                     ON L.IdLink = LT.IdLink 
                      GROUP  BY LT.IdSubscriber, 
                                L.IdCampaign) C 
                  ON C.IdSubscriber = cdoi.IdSubscriber 
                     AND C.IdCampaign = cdoi.IdCampaign 
           JOIN Subscriber s WITH(NOLOCK) 
             ON cdoi.IdSubscriber = s.IdSubscriber 
                AND s.email LIKE @emailFilter 
                AND ISNULL(s.Firstname, '') LIKE @firstnameFilter 
                AND ISNULL(s.lastname, '') LIKE @lastnameFilter 
    GROUP  BY CO.Name, 
              CO.Code 