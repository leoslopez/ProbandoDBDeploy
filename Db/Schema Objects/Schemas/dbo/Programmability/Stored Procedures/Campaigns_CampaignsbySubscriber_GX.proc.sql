CREATE PROCEDURE [dbo].[Campaigns_CampaignsbySubscriber_GX] 
@IdSubscriber BIGINT, 
@howmany      INT 
AS 
    SET ROWCOUNT @howmany 

    SELECT c.[Name]           as Name, 
           c.[Subject]     as 'Subject', 
           c.UTCSentDate as UTCSentDate, 
           LT.ClickCount, 
           CASE u.IdDeliveryStatus 
             WHEN 100 THEN 2 
             WHEN 0 THEN 0 
             WHEN 2 THEN 1001 
             WHEN 8 THEN 1001 
             WHEN 101 THEN 3 
             ELSE 1000 
           END  'Status' 
    FROM   (SELECT u.IdCampaign, u.IdDeliveryStatus 
			FROM CampaignDeliveriesOpenInfo u WITH(NOLOCK) 
			WHERE  u.IdSubscriber = @IdSubscriber  ) u
           JOIN Campaign C WITH(NOLOCK) 
             ON u.IdCampaign = C.IdCampaign 
           LEFT JOIN (SELECT L.IdCampaign, 
                             ISNULL(SUM(lt.Count), 0) as ClickCount 
                      FROM   LinkTracking LT WITH(NOLOCK) 
                             JOIN Link L WITH(NOLOCK) 
                               ON L.IdLink = LT.IdLink 
                      WHERE  LT.IdSubscriber = @IdSubscriber 
                      GROUP  BY L.IdCampaign) LT 
                  ON LT.IdCampaign = c.IdCampaign 
    ORDER  BY UTCSentDate desc 
