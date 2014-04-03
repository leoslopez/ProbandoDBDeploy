CREATE PROCEDURE [dbo].[Statistics_AperturesCitiesByCountry_GX]
@IdCampaign INT,      
@StartDate DATETIME,      
@EndDate DATETIME,  
@NAME varchar(100)  
AS  
    SET @StartDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), @StartDate, 101), 101) 
    SET @EndDate = DATEADD(dd, 1, @EndDate) 
    SET @EndDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), @EndDate, 101), 101) 

    DECLARE @t TABLE 
      ( 
         idcampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT idcampaign 
    FROM   Gettestabset(@IdCampaign) 

    SELECT L.City, 
           l.Latitude, 
           l.Longitude, 
           SUM(ISNULL(cdoi.Count, 1))  CantOpen, 
           SUM(ISNULL(S.CantClick, 0)) CantClick 
    FROM   @t t 
           JOIN campaigndeliveriesopeninfo cdoi WITH(NOLOCK) 
             ON cdoi.idcampaign = t.idcampaign 
                AND IdDeliveryStatus = 100 
                AND cdoi.Date BETWEEN @StartDate AND @EndDate 
           JOIN dbo.Location L WITH(NOLOCK) 
             ON cdoi.LocId = L.LocId 
           JOIN Country CO WITH(NOLOCK) 
             ON CO.Code = L.Country 
                AND CO.Name = @NAME 
           LEFT JOIN (SELECT LT.IdSubscriber, 
                             L.IdCampaign, 
                             SUM(LT.Count) as CantClick 
                      FROM   LinkTracking LT WITH(NOLOCK) 
                             INNER JOIN Link L WITH(NOLOCK) 
                                     ON L.IdLink = LT.IdLink 
                      GROUP  BY LT.IdSubscriber, 
                                L.IdCampaign) S 
                  ON S.IdSubscriber = cdoi.IdSubscriber 
                     AND S.IdCampaign = cdoi.IdCampaign 
    GROUP  BY L.City, 
              l.Latitude, 
              l.Longitude 