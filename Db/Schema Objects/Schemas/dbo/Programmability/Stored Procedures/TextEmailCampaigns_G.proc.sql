/****** Object:  StoredProcedure [dbo].[TextEmailCampaigns_G]    Script Date: 08/07/2013 11:45:06 ******/

CREATE PROCEDURE [dbo].[TextEmailCampaigns_G] @Idcampaign int 
AS 
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
           COALESCE(c.UTCScheduleDate, '') 
           UTCScheduleDate, 
			COALESCE(substring(convert(varchar, c.UTCScheduleDate, 120), 12, 2), '') 
			+ COALESCE(substring(convert(varchar, c.UTCScheduleDate, 120), 15, 2), '') 
	           Time, 
			COALESCE(c.IdSendingTimeZone, '') 
				IdSendingTimeZone, 
			c.DeliveryType, 
			co.Content, 
			3  as Substatus 
    FROM   dbo.Campaign c WITH (NOLOCK) 
           JOIN dbo.Content co WITH (NOLOCK) 
             ON c.IdCampaign = co.IdCampaign 
           LEFT JOIN (SELECT DISTINCT p1.IdCampaign, 
                                      ConfirmEmails 
                      FROM   dbo.MailConfirmationXCampaign p1 
                             CROSS APPLY (SELECT m.Mail + ',' 
                                          FROM   dbo.MailConfirmationXCampaign 
                                                 p2 
                                                 WITH( 
                                                 NOLOCK) 
                                                 JOIN dbo.MailConfirmation m 
                                                      WITH( 
                                                      NOLOCK) 
                                                   ON 
    p2.IdMailConfirmation = m.IdMailConfirmation 
     WHERE  p2.IdCampaign = p1.IdCampaign 
     ORDER  BY p2.IdMailConfirmation 
     FOR XML PATH('')) D ( ConfirmEmails ))t 
    ON c.IdCampaign = t.IdCampaign 
    WHERE  c.IdCampaign = @Idcampaign 