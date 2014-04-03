CREATE PROCEDURE [dbo].[Campaigns_G] @IdCampaign int 
AS 
SELECT	c.IdCampaign, 
		c.[Name], 
		c.[Subject], 
		c.FromName, 
		c.FromEmail, 
		CASE 
			WHEN ( c.ContentType = 2) THEN 1 
			ELSE 4 
		end CampaignTypes, 
		c.ReplyTo, 
		c.[Status], 
		c.IdUser, 
		t.Ids, 
		COALESCE(c.UTCSentDate, '') AS ScheduleDeliveryDate, 
		COALESCE(substring(convert(varchar, c.UTCScheduleDate, 120), 12, 2), '') +
		COALESCE(substring(convert(varchar, c.UTCScheduleDate, 120), 15, 2), '') as 'Time', 
		COALESCE(c.IdSendingTimeZone, '') AS TimeZoneID, 
		CASE 
			WHEN ( c.DeliveryType = 3 OR c.DeliveryType = 1) THEN 0 
			ELSE 1 
		end SendInmediate, 
		c.RSSContent, 
		c.EnabledRSS, 
		c.EnabledShareSocialNetwork, 
		3 as SubstatusID 
FROM dbo.Campaign c WITH(NOLOCK) 
LEFT JOIN (SELECT DISTINCT p1.IdCampaign, IDS 
			FROM dbo.MailConfirmationXCampaign p1 WITH(NOLOCK) 
			CROSS APPLY (SELECT m.Mail + ',' 
						FROM dbo.MailConfirmationXCampaign p2 WITH(NOLOCK) 
						JOIN dbo.MailConfirmation m WITH(NOLOCK) 
						ON p2.IdMailConfirmation = m.IdMailConfirmation 
						WHERE p2.IdCampaign = p1.IdCampaign 
						ORDER BY p2.IdMailConfirmation 
FOR XML PATH('')) D ( Ids ))t 
ON c.IdCampaign = t.IdCampaign 
WHERE C.IdCampaign = @IdCampaign 

GO 