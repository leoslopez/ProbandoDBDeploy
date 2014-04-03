
CREATE PROCEDURE [dbo].[Statistics_LinksByCampaign_GX] @IdCampaign INT 
AS 
  BEGIN 
      SELECT L.IdLink, 
             [dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) UrlLink, 
             SUM(LT.Count)                                          ClickCount, 
             COUNT(LT.Count) 
             UniqueClickCount 
      FROM   Link L WITH(NOLOCK) 
             INNER JOIN LinkTracking LT WITH(NOLOCK) 
                     ON LT.IdLink = L.IdLink 
      WHERE  L.IdCampaign = @IdCampaign 
      GROUP  BY L.IdLink, 
                lt.IdLink 
  END 