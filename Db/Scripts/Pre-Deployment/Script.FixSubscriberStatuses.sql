-- =================================================
-- Pre-deployment script to fix subscriber statuses.
-- =================================================

SET IDENTITY_INSERT SubscriberStatus ON

INSERT [dbo].[SubscriberStatus] ([IdSubscriberStatus], [Name], [EditionLocked]) VALUES (6, N'Unsubscribed by Never Opened', NULL)
INSERT [dbo].[SubscriberStatus] ([IdSubscriberStatus], [Name], [EditionLocked]) VALUES (7, N'Pending', 1)
INSERT [dbo].[SubscriberStatus] ([IdSubscriberStatus], [Name], [EditionLocked]) VALUES (8, N'Unsubscribed by Client', NULL)

SET IDENTITY_INSERT SubscriberStatus OFF

UPDATE Subscriber
SET IdSubscribersStatus = 6
WHERE IdSubscribersStatus = 172

UPDATE Subscriber
SET IdSubscribersStatus = 7
WHERE IdSubscribersStatus = 171

DELETE FROM SubscriberStatus
WHERE IdSubscriberStatus IN (171, 172)