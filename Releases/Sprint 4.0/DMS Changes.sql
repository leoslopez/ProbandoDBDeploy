CREATE TABLE [dbo].[DMS] (
    [IdDMS]       INT           NOT NULL,
    [Description] VARCHAR (MAX) NULL,
    [IsFast]      BIT           NULL
);


GO
ALTER TABLE [dbo].[DMS]
    ADD CONSTRAINT [PK_DMS] PRIMARY KEY CLUSTERED ([IdDMS] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO

INSERT INTO [dbo].[DMS] (Description, IsFast) VALUES
(0, 'DMS Fast',1),
(1, 'DMS Normal',0),
(2, 'DMS Normal Exclusive',0)
GO


--User update

ALTER TABLE dbo.[User]
	ADD [IdDMSFast]  INT NOT NULL DEFAULT 0;
GO
ALTER TABLE dbo.[User]
	ADD [IdDMSNormal]  INT NOT NULL DEFAULT 0;
GO

ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_DMSFast] FOREIGN KEY ([IdDMSFast]) REFERENCES [dbo].[DMS] ([IdDMS]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_DMSNormal] FOREIGN KEY ([IdDMSNormal]) REFERENCES [dbo].[DMS] ([IdDMS]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO


--Update SP

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

ALTER PROCEDURE [dbo].[CampaignsReadyToQueue_G] @Status    INT, 
                                                @Queued    BIT, 
                                                @IdDMS	   SMALLINT=1
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
      WHERE  c.status = @Status 
             AND c.Queued = @Queued 
             AND ( ( u.IdDMSFast = @IdDMS 
                     AND c.AmountSubscribersToSend <= @FastLimit ) 
                    OR ( u.IdDMSNormal = @IdDMS 
                         AND c.AmountSubscribersToSend > @FastLimit ) ) 
      ORDER  BY c.idcampaign 
  END 
GO





CREATE PROCEDURE [dbo].[GetAmountSubscribersToSend] (@IdCampaign int) 
AS 
	SET NOCOUNT ON;
	
	DECLARE @Amount INT
	
    SELECT @Amount = SUM(vsla.Amount) 
    FROM   dbo.ViewSubscribersListsSubscribersAmount vsla
    JOIN dbo.SubscribersListXCampaign slxc on vsla.IdSubscribersList = slxc.IdSubscribersList
    WHERE  slxc.IdCampaign = @IdCampaign
    
    SELECT @Amount AS Amount	
GO

