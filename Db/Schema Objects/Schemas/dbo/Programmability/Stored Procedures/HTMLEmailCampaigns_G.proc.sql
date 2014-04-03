CREATE PROCEDURE [dbo].[HTMLEmailCampaigns_G] @Idcampaign int 
AS 
SET NOCOUNT ON

SELECT c.IdCampaign, 
c.[Name], 
c.[Subject], 
c.FromName, 
c.FromEmail, 
c.ContentType, 
c.ReplyTo, 
c.[Status], 
c.IdUser, 
t.ConfirmEmails, 
c.RSSContent, 
c.EnabledRSS, 
c.EnabledShareSocialNetwork, 
COALESCE(c.UTCScheduleDate, '') as UTCScheduleDate, 
COALESCE(substring(convert(varchar, c.UTCScheduleDate, 120), 12, 2), '') 
+ COALESCE(substring(convert(varchar, c.UTCScheduleDate, 120), 15, 2), '') as Time, 
COALESCE(c.IdSendingTimeZone, '')  as IdSendingTimeZone, 
c.DeliveryType, 
co.Content, 
co.PlainText, 
'', 
0, 
0, 
'', 
0, 
3 
FROM dbo.Campaign c WITH (NOLOCK) 
JOIN dbo.Content co WITH (NOLOCK) 
ON c.IdCampaign = co.IdCampaign 
LEFT JOIN (SELECT DISTINCT p1.IdCampaign, ConfirmEmails 
		FROM dbo.MailConfirmationXCampaign p1 WITH (NOLOCK) 
		CROSS APPLY (SELECT m.Mail + ',' 
					FROM dbo.MailConfirmationXCampaign p2 WITH(NOLOCK) 
					JOIN dbo.MailConfirmation m WITH(NOLOCK) 
					ON p2.IdMailConfirmation = m.IdMailConfirmation 
					WHERE p2.IdCampaign = p1.IdCampaign 
					ORDER BY p2.IdMailConfirmation 
					FOR XML PATH('')) D ( ConfirmEmails ))t 
ON c.IdCampaign = t.IdCampaign 
WHERE c.IdCampaign = @Idcampaign 

GO 
