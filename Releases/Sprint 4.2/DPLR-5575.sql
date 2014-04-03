ALTER TABLE dbo.Subscriber
ADD UnsubscriptionSubreason int,
	UnsubscriptionDescription VARCHAR(200)

SET IDENTITY_INSERT [dbo].[UnsubscriptionReason] ON
	INSERT [dbo].[UnsubscriptionReason] ([IdUnsubscriptionReason], [Name], [VisibleByUser]) VALUES (4, N'BySubscriber', 0)
SET IDENTITY_INSERT [dbo].[UnsubscriptionReason] OFF