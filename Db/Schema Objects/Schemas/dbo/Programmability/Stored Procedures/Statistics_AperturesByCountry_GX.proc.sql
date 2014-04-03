
CREATE PROCEDURE [dbo].[Statistics_AperturesByCountry_GX] @IdCampaign INT, 
                                                         @StartDate  DATETIME, 
                                                         @EndDate    DATETIME, 
                                                         @StatusID   INT 
AS 

SET NOCOUNT ON;
    SET @StartDate = Dateadd(hh, -1, @StartDate) 
    SET @StartDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), @StartDate, 101), 101) 
    SET @EndDate = Dateadd(dd, 1, @EndDate) 
    SET @EndDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), @EndDate, 101), 101) 

  BEGIN 
      DECLARE @t TABLE 
        ( 
           idcampaign INT PRIMARY KEY 
        ); 

      INSERT INTO @t 
      SELECT idcampaign 
      FROM   Gettestabset(@IdCampaign) 

      SELECT CO.name, 
             CO.code, 
             Sum(cdoi.count)             CantOpen, 
             Sum(Isnull(S.cantclick, 0)) AS CantClick 
      FROM   (SELECT cdoi.LocId, 
                     cdoi.IdSubscriber, 
                     cdoi.IdCampaign, 
                     cdoi.Count 
              FROM   @t t 
                     JOIN dbo.campaigndeliveriesopeninfo cdoi WITH(nolock) 
                       ON cdoi.idcampaign = t.idcampaign 
                          AND cdoi.IdDeliveryStatus = 100 
                          AND cdoi.Date BETWEEN @StartDate AND @EndDate) as cdoi 
             JOIN dbo.location L WITH(nolock) 
               ON cdoi.locid = L.locid 
             JOIN dbo.country CO WITH(nolock) 
               ON CO.code = L.country 
             LEFT JOIN (SELECT LT.idsubscriber, 
                               L.idcampaign, 
                               Sum(LT.count) AS CantClick 
                        FROM   dbo.linktracking LT WITH(nolock) 
                               INNER JOIN link L WITH(nolock) 
                                       ON L.idlink = LT.idlink 
                               JOIN @t t 
                                 ON l.idcampaign = t.idcampaign 
                        GROUP  BY LT.idsubscriber, 
                                  L.idcampaign) S 
                    ON S.idsubscriber = cdoi.idsubscriber 
                       AND S.idcampaign = cdoi.idcampaign 
      GROUP  BY CO.name, 
                CO.code OPTION
 (OPTIMIZE FOR (@StartDate UNKNOWN, @EndDate UNKNOWN))
  END 