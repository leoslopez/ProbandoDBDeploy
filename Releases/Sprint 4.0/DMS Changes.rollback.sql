
--Update SP
ALTER PROCEDURE [dbo].[Campaignsreadytoqueue_g] 
@status    INT, 
@queued    BIT, 
@DMSLiteID SMALLINT=0 
AS 
SET NOCOUNT ON

IF ( @DMSLiteID = 0 ) 
BEGIN 
	SELECT c.idcampaign, 
	c.idsendingtimezone, 
	COALESCE(c.utcscheduledate, '') 
	UTCScheduleDate, 
	COALESCE(Substring(CONVERT(VARCHAR, c.utcscheduledate, 120), 12, 2), '') as [Time],	CASE 
		WHEN ( c.DeliveryType = 3 OR c.DeliveryType = 1) THEN 'false' 
		ELSE 'true' 
	end SendInmediate, 
	t.confirmemails, 
	Datediff([minute], c.utcscheduledate, GetUTCdate()) AS minToSend, 
	c.queued 
	FROM dbo.campaign c WITH(nolock) 
	JOIN [user] u  WITH(nolock) 
	ON u.iduser = c.iduser 
	AND EXISTS (SELECT sl.idsubscriberslist 
				FROM dbo.subscriberslistxcampaign slxc WITH(nolock) 
				JOIN dbo.subscriberslist sl WITH(nolock) 
				ON slxc.idsubscriberslist = sl.idsubscriberslist 
				AND SL.active = 1 
				WHERE  c.idcampaign = slxc.idcampaign) 
	LEFT JOIN (SELECT DISTINCT p1.idcampaign, confirmemails 
				FROM dbo.mailconfirmationxcampaign p1 WITH(nolock) 
				CROSS apply (SELECT m.mail + ',' 
							FROM dbo.mailconfirmationxcampaign p2 WITH(nolock) 
							JOIN dbo.mailconfirmation m WITH(nolock) 
							ON p2.idmailconfirmation = m.idmailconfirmation 
							WHERE p2.idcampaign = p1.idcampaign 
							ORDER BY p2.idmailconfirmation 
							FOR xml path('')) D ( confirmemails ))t 
	ON c.idcampaign = t.idcampaign 
	WHERE  c.status = @status AND c.queued = @queued 
	AND u.iduser NOT IN ( 13730, 25490, 17373, 12790, 
                            13846, 16765, 18164, 18184, 
                            4838, 13334, 12436, 11856, 
                            18227, 12230, 12227, 
                            18265 ) 
	ORDER BY c.idcampaign 
END 
ELSE 
BEGIN 
	SELECT c.idcampaign, 
	c.idsendingtimezone, 
	COALESCE(c.utcscheduledate, '') 
	UTCScheduleDate, 
	COALESCE(Substring(CONVERT(VARCHAR, c.utcscheduledate, 120), 12, 2), '') as [Time], 
	COALESCE(c.idsendingtimezone, '') 
	IdSendingTimeZone, 
	t.confirmemails, 
	Datediff([minute], c.utcscheduledate, Getdate()) AS minToSend, 
	c.queued 
	FROM dbo.campaign c WITH(nolock) 
	JOIN [user] u WITH(nolock) 
	ON u.iduser = c.iduser 
	AND EXISTS (SELECT sl.idsubscriberslist 
				FROM dbo.subscriberslistxcampaign slxc WITH(nolock) 
				JOIN dbo.subscriberslist sl WITH(nolock) 
				ON slxc.idsubscriberslist = sl.idsubscriberslist 
				AND SL.active = 1 
				WHERE  c.idcampaign = slxc.idcampaign) 
	LEFT JOIN (SELECT DISTINCT p1.idcampaign, confirmemails 
				FROM dbo.mailconfirmationxcampaign p1 WITH(nolock) 
				CROSS apply (SELECT m.mail + ',' 
							FROM dbo.mailconfirmationxcampaign p2 WITH(nolock) 
							JOIN dbo.mailconfirmation m WITH(nolock) 
							ON p2.idmailconfirmation = m.idmailconfirmation 
							WHERE p2.idcampaign = p1.idcampaign 
							ORDER BY p2.idmailconfirmation 
							FOR xml path('')) D ( confirmemails ))t 
	ON c.idcampaign = t.idcampaign 
	WHERE c.status = @status AND c.queued = @queued 
	AND u.iduser IN ( 13730, 25490, 17373, 12790, 
                        13846, 16765, 18164, 18184, 
                        4838, 13334, 12436, 11856, 
                        18227, 12230, 12227, 
                        18265 ) 
	ORDER BY c.idcampaign 
END 