CREATE PROCEDURE [dbo].[Statistics_TopClickedLinksByCampaign_GX]
@IDCampaign INT,      
@StartDate DATETIME,      
@EndDate DATETIME,      
@HowMany INT,  
@IDStatus INT    
AS      
 
 
  BEGIN 
      SET @StartDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), @StartDate, 101), 101) 
      SET @EndDate = DATEADD(dd, 1, CONVERT(DATETIME, CONVERT(VARCHAR(10), @EndDate, 101), 101))

      DECLARE @t TABLE 
        ( 
           idcampaign INT PRIMARY KEY 
        ); 

      INSERT INTO @t 
      SELECT idcampaign 
      FROM   Gettestabset(@IdCampaign) 

      SELECT TOP (@HowMany) LT.IdLink, 
             SUM(ISNULL(LT.Count, 1))   ClickCount, 
             COUNT(ISNULL(LT.Count, 1)) UniqueClickCount, 
             [dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) UrlLink 
      FROM   @t t 
             JOIN dbo.Link L WITH(NOLOCK) 
               ON t.idcampaign = L.IdCampaign 
             JOIN LinkTracking LT WITH(NOLOCK) 
               ON LT.IdLink = L.IdLink 
      WHERE LT.[Date] BETWEEN @StartDate AND @EndDate 
      GROUP  BY LT.IdLink, 
                UrlLink 
      ORDER  BY SUM(ISNULL(LT.Count, 1)) DESC 
  END 