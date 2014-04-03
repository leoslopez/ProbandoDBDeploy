CREATE PROCEDURE [dbo].[CampaignScheduleDeliveries_G] 
@Idcampaign int 
AS 
SELECT c.IdCampaign, IdSendingTimeZone, 
COALESCE(c.UTCScheduleDate, '') UTCScheduleDate,
COALESCE(substring(convert(varchar,c.UTCScheduleDate,120),12,2),'') Time, 
c.DeliveryType,
ConfirmEmails 
FROM Campaign c WITH(NOLOCK) 
LEFT JOIN (SELECT DISTINCT p1.IdCampaign, SUBSTRING(ConfirmEmails, 0, LEN(ConfirmEmails)) as ConfirmEmails
FROM dbo.MailConfirmationXCampaign p1
CROSS APPLY ( SELECT m.Mail + ',' 
FROM dbo.MailConfirmationXCampaign p2 WITH(NOLOCK) 
JOIN dbo.MailConfirmation m WITH(NOLOCK) 
ON p2.IdMailConfirmation=m.IdMailConfirmation 
WHERE p2.IdCampaign = p1.IdCampaign 
ORDER BY p2.IdMailConfirmation 
FOR XML PATH('') ) D ( ConfirmEmails )
)t 
ON c.IdCampaign=t.IdCampaign 
WHERE (c.IdCampaign = @Idcampaign)