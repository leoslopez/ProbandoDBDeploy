PRINT 'Create [UnsubscriptionReason] table'
CREATE TABLE [dbo].[UnsubscriptionReason]
(
	[IdUnsubscriptionReason]	INT    IDENTITY (1, 1) NOT NULL,
    [Name]						VARCHAR (150)	NOT NULL,
    [VisibleByUser]				BIT				NOT NULL
)

GO

PRINT 'Create [PK_UnsubscriptionReason]'
ALTER TABLE [dbo].[UnsubscriptionReason]
    ADD CONSTRAINT [PK_UnsubscriptionReason] PRIMARY KEY CLUSTERED ([IdUnsubscriptionReason] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
    
GO

PRINT 'Alter [IdUnsubscriptionReason] in [Subscriber] table'
ALTER TABLE [dbo].[Subscriber] ADD [IdUnsubscriptionReason] INT NULL

GO

PRINT 'Create [FK_Subscriber_UnsubscriptionReason]'
ALTER TABLE [dbo].[Subscriber]
    ADD CONSTRAINT [FK_Subscriber_UnsubscriptionReason] FOREIGN KEY ([IdUnsubscriptionReason]) REFERENCES [dbo].[UnsubscriptionReason] ([IdUnsubscriptionReason]) ON DELETE NO ACTION ON UPDATE NO ACTION;

GO

PRINT 'Insert values into [UnsubscriptionReason] table'
SET IDENTITY_INSERT [dbo].[UnsubscriptionReason] ON
INSERT [dbo].[UnsubscriptionReason] ([IdUnsubscriptionReason], [Name], [VisibleByUser]) VALUES (1, N'BlackList', 0)
INSERT [dbo].[UnsubscriptionReason] ([IdUnsubscriptionReason], [Name], [VisibleByUser]) VALUES (2, N'JRM', 0)
INSERT [dbo].[UnsubscriptionReason] ([IdUnsubscriptionReason], [Name], [VisibleByUser]) VALUES (3, N'None', 0)
SET IDENTITY_INSERT [dbo].[UnsubscriptionReason] OFF

GO

PRINT 'Alter [UnSubscribe_Subscripters] SP'
GO
ALTER PROCEDURE [dbo].[UnSubscribe_Subscripters] @Table TypeUnSubscriber READONLY 
AS
BEGIN
	SET NOCOUNT ON 

	MERGE Subscriber WITH (HOLDLOCK) AS [Target]
	USING (SELECT * FROM @Table t) AS [Source] 
      ON ([Target].IdSubscriber = [Source].IdSubscriber)
	
	WHEN MATCHED THEN
		UPDATE
		SET [Target].IdSubscribersStatus = 5,
		    [Target].UTCUnsubDate = GETUTCDATE(),
		    [Target].IdCampaign = [Source].IdCampaign,
			[Target].IdUnsubscriptionReason = 2;
        
	
	  DELETE FROM [dbo].[SubscriberXList]
		FROM  [dbo].[SubscriberXList] sxl
			JOIN @Table t on sxl.IdSubscriber = t.IdSubscriber

END
GO

PRINT 'Update Subscribers From BlackList'
GO

CREATE PROCEDURE [dbo].[MarkSubscribersFromBlackList]
AS
BEGIN
	DECLARE @Table TABLE (IdSubscriber INT, Email varchar(250))

	INSERT INTO @Table (IdSubscriber, Email)
	SELECT TOP 100000 s.IdSubscriber, s.Email 
	FROM dbo.Subscriber s
	WHERE s.IdSubscribersStatus = 5 AND s.IdUnsubscriptionReason IS NULL

	UPDATE Dbo.Subscriber
		SET IdUnsubscriptionReason = (CASE	
										WHEN Ble.Email IS NOT NULL  OR bld.Domain IS NOT NULL THEN 1
									    ELSE 3
									  END)
	FROM dbo.Subscriber s WITH(NOLOCK)
	JOIN @Table T on T.IdSubscriber = s.IdSubscriber
	LEFT JOIN dbo.BlackListEmail ble WITH(NOLOCK) on T.Email = ble.Email
	LEFT JOIN dbo.BlackListDomain bld WITH(NOLOCK) on T.Email like bld.Domain


END
GO
