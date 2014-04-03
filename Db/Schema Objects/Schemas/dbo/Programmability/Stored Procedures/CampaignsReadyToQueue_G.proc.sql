CREATE PROCEDURE [dbo].[Campaignsreadytoqueue_g] @Status INT, 
                                                @Queued BIT, 
                                                @DMSLiteId  SMALLINT=1 
AS 
    SET NOCOUNT ON 

  BEGIN 
      DECLARE @FastLimit INT 

      SET @FastLimit = 3200 

      SELECT c.idcampaign, 
             c.idsendingtimezone, 
             COALESCE(c.utcscheduledate, '')                                          UTCScheduleDate,
             COALESCE(Substring(CONVERT(VARCHAR, c.utcscheduledate, 120), 12, 2), '') AS [Time],
             CASE 
               WHEN ( c.DeliveryType = 3 
                       OR c.DeliveryType = 1 ) THEN 'false' 
               ELSE 'true' 
             END                                                                      SendInmediate,
             t.confirmemails, 
             Datediff([minute], c.utcscheduledate, GetUTCdate())                      AS minToSend,
             c.queued 
      FROM   dbo.campaign c WITH(nolock) 
             JOIN [user] u WITH(nolock) 
               ON u.iduser = c.iduser 
                  AND EXISTS (SELECT sl.idsubscriberslist 
                              FROM   dbo.subscriberslistxcampaign slxc WITH(nolock) 
                                     JOIN dbo.subscriberslist sl WITH(nolock) 
                                       ON slxc.idsubscriberslist = sl.idsubscriberslist 
                                          AND SL.active = 1 
                              WHERE  c.idcampaign = slxc.idcampaign) 
             LEFT JOIN (SELECT DISTINCT p1.idcampaign, 
                                        confirmemails 
                        FROM   dbo.mailconfirmationxcampaign p1 WITH(nolock) 
                               CROSS apply (SELECT m.mail + ',' 
                                            FROM   dbo.mailconfirmationxcampaign p2 WITH(nolock)
                                                   JOIN dbo.mailconfirmation m WITH(nolock) 
                                                     ON p2.idmailconfirmation = m.idmailconfirmation
                                            WHERE  p2.idcampaign = p1.idcampaign 
                                            ORDER  BY p2.idmailconfirmation 
                                            FOR xml path('')) D ( confirmemails ))t 
                    ON c.IdCampaign = t.IdCampaign 
      WHERE  ( c.status = @Status 
                OR ( c.Status = 10 
                     AND c.UTCDMSLastUpdate IS NOT NULL 
                     AND c.DMSSplited = 1 
                     AND Datediff([minute], c.UTCDMSLastUpdate, GetUTCdate()) > 10 ) ) 
             AND c.Queued = @Queued 
             AND ( ( u.IdDMSFast = @DMSLiteId 
                     AND c.AmountSubscribersToSend <= @FastLimit ) 
                    OR ( u.IdDMSNormal = @DMSLiteId 
                         AND c.AmountSubscribersToSend > @FastLimit ) ) 
             AND u.Email NOT LIKE '%.ru'
      ORDER  BY c.idcampaign 
  END 
