-- =============================================
-- Script Template
-- =============================================
ALTER TABLE [dbo].[User]
ADD [IsAbuseLinkVisible] BIT DEFAULT ((1)) NOT NULL

GO

ALTER TABLE [dbo].[User]
ADD [TotalCampaignsWithAbuseLink] INT DEFAULT ((-1)) NOT NULL

GO

ALTER TABLE [dbo].[User]
ADD [TotalSentCampaignsWithoutAbuse] INT DEFAULT ((0)) NOT NULL

GO

UPDATE u SET [IsAbuseLinkVisible] = 0 From [User] u WHERE EXISTS (SELECT * FROM BillingCredits BC where BC.IdUser = u.IdUser)

GO


SET IDENTITY_INSERT [dbo].[UnsubscriptionReason] ON
	INSERT [dbo].[UnsubscriptionReason] ([IdUnsubscriptionReason], [Name], [VisibleByUser]) VALUES (5, N'Abuse by reputation', 0)
SET IDENTITY_INSERT [dbo].[UnsubscriptionReason] OFF
