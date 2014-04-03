
CREATE PROCEDURE [dbo].[Statistics_TopClickedLinksByCampaignAndFilter_GX] 
@IDCampaign      INT, 
@StartDate       DATETIME, 
@EndDate         DATETIME, 
@emailFilter     varchar(50), 
@firstnameFilter varchar(50), 
@lastnameFilter  varchar(50), 
@HowMany         INT 
AS 
  BEGIN 
      SET @StartDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), @StartDate, 101), 
                       101) 
      SET @EndDate = DATEADD(dd, 1, CONVERT(DATETIME, CONVERT(VARCHAR(10), 
                                                      @EndDate, 101), 101)) 

      DECLARE @t TABLE 
        ( 
           idcampaign INT PRIMARY KEY 
        ); 

      INSERT INTO @t 
      SELECT idcampaign 
      FROM   Gettestabset(@IdCampaign) 

      SELECT TOP (@HowMany) LT.IdLink, 
                            SUM(ISNULL(LT.Count, 1)) 
                            ClickCount, 
                            COUNT(ISNULL(LT.Count, 1)) 
                            UniqueClickCount, 
                            [dbo].[GetUrlLinkCustomParsed](@IDCampaign, 
                            lt.IdLink) 
                            UrlLink 
      FROM   @t t 
             JOIN dbo.Link L WITH(NOLOCK) 
               ON t.idcampaign = L.IdCampaign 
             JOIN LinkTracking LT WITH(NOLOCK) 
               ON LT.IdLink = L.IdLink 
                  AND LT.[Date] BETWEEN @StartDate AND @EndDate 
             JOIN Subscriber s WITH(NOLOCK) 
               ON s.IdSubscriber = LT.IdSubscriber 
      WHERE  s.Email like @emailFilter 
             AND ISNULL(s.Firstname, '') like @firstnameFilter 
             AND ISNULL(s.lastname, '') like @lastnameFilter 
      GROUP  BY LT.IdLink, 
                UrlLink 
      ORDER  BY SUM(ISNULL(LT.Count, 1)) desc 
  END 