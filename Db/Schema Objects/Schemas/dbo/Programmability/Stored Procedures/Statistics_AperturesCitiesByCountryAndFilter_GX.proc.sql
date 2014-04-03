CREATE PROCEDURE [dbo].[Statistics_AperturesCitiesByCountryAndFilter_GX]
@IdCampaign INT,      
@StartDate DATETIME,      
@EndDate DATETIME,  
@NAME varchar(100),
@emailFilter varchar(50),  
@firstnameFilter varchar(50),  
@lastnameFilter varchar(50)  
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

    SELECT L.City, 
           l.Latitude, 
           l.Longitude, 
           SUM(ISNULL(cdoi.Count, 1))   CantOpen, 
           SUM(ISNULL(LC.CantClick, 0)) CantClick 
    FROM   @t t 
           JOIN CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
             ON cdoi.IdCampaign = t.IdCampaign 
                AND IdDeliveryStatus = 100 
                and cdoi.Date BETWEEN @StartDate AND @EndDate 
           JOIN dbo.Location L WITH(NOLOCK) 
             ON cdoi.LocId = L.LocId 
           JOIN Country CO WITH(NOLOCK) 
             ON CO.Code = L.Country 
                AND CO.Name = @NAME 
           JOIN Subscriber s WITH(NOLOCK) 
             ON cdoi.IdSubscriber = s.IdSubscriber 
           LEFT JOIN (SELECT LT.IdSubscriber, 
                             L.IdCampaign, 
                             SUM(LT.Count) as CantClick 
                      FROM   LinkTracking LT WITH(NOLOCK) 
                             INNER JOIN Link L WITH(NOLOCK) 
                                     ON L.IdLink = LT.IdLink 
                      GROUP  BY LT.IdSubscriber, 
                                L.IdCampaign) LC 
                  ON LC.IdSubscriber = cdoi.IdSubscriber 
                     AND LC.IdCampaign = cdoi.IdCampaign 
    WHERE  s.email like @emailFilter 
           AND ISNULL(s.Firstname, '') like @firstnameFilter 
           AND ISNULL(s.lastname, '') like @lastnameFilter 
    GROUP  BY L.City, 
              l.Latitude, 
              l.Longitude 