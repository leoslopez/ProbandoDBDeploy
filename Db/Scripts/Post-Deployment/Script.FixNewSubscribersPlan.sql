-- ======================================================================
-- Post-deployment script to fix all the related to new subscribers plan.
-- ======================================================================
UPDATE SubscriberStatus
SET IsForMonthlyBySubscriber = 1

UPDATE SubscriberStatus
SET IsForMonthlyBySubscriber = 0
WHERE IdSubscriberStatus IN (3,4,5,7)

DECLARE @Group integer
SET @Group = 0;
SELECT @Group = COUNT(*) FROM [dbo].[UserTypes] WHERE [IdUserType] = 4
IF (@Group = 0)
begin
SET IDENTITY_INSERT [dbo].[UserTypes] ON
	INSERT [dbo].[UserTypes] ([IdUserType], [Description], [Active]) VALUES (4, N'Subscribers', NULL)
SET IDENTITY_INSERT [dbo].[UserTypes] OFF
end

UPDATE Promotions
SET [IdUserTypePlan] = 0

UPDATE BillingCredits
SET [IdUserTypePlan] = 0

delete [dbo].[UserTypesPlans] where [IdUserTypePlan] != 0
SET IDENTITY_INSERT [dbo].[UserTypesPlans] ON		
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (1, 3, N'1,500', 1500, 33, NULL, NULL, NULL, NULL)		
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (2, 3, N'2,500', 2500, 45, NULL, NULL, NULL, NULL)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (3, 3, N'5,000', 5000, 85, NULL, NULL, NULL, NULL)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (4, 3, N'10,000', 10000, 120, NULL, NULL, NULL, NULL)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (5, 3, N'15,000', 15000, 185, NULL, NULL, NULL, NULL)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (6, 3, N'25,000', 25000, 250, NULL, NULL, NULL, NULL)		
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (7, 3, N'50,000', 50000, 400, NULL, NULL, NULL, NULL)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (8, 3, N'100,000', 100000, 600, NULL, NULL, NULL, NULL)				
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (9, 3, N'Exclusive Individual', NULL, NULL, NULL, NULL, NULL, NULL)	
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (10, 2, N'200,000', 200000, 510, 0.0026, NULL, NULL, NULL)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (11, 2, N'300,000', 300000, 637, 0.0021, NULL, NULL, NULL)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (12, 2, N'500,000', 500000, 825, 0.0017, NULL, NULL, NULL)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (13, 2, N'1,000,000', 1000000, 1275, 0.0013, NULL, NULL, NULL)		
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (14, 2, N'1,500,000', 1500000, 1575, 0.0011, NULL, NULL, NULL)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (15, 2, N'2,000,000', 2000000, 1875, 0.0009, NULL, NULL, NULL)		
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (16, 2, N'2,500,000', 2500000, 2100, 0.0008, NULL, NULL, NULL)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active]) VALUES (17, 2, N'Exclusive Monthly', NULL, NULL, NULL, NULL, NULL, NULL)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active],[SubscribersQty]) VALUES (18, 4, N'501-1500', NULL, 15, NULL, NULL, NULL, NULL,1500)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active],[SubscribersQty]) VALUES (19, 4, N'1501-2500', NULL, 29, NULL, NULL, NULL, NULL,2500)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active],[SubscribersQty]) VALUES (20, 4, N'2501-5000', NULL, 48, NULL, NULL, NULL, NULL,5000)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active],[SubscribersQty]) VALUES (21, 4, N'5001-10000', NULL, 77, NULL, NULL, NULL, NULL,10000)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active],[SubscribersQty]) VALUES (22, 4, N'10001-15000', NULL, 106, NULL, NULL, NULL, NULL,15000)
	INSERT [dbo].[UserTypesPlans] ([IdUserTypePlan], [IdUserType], [Description], [EmailQty], [Fee], [ExtraEmailCost], [IdUser], [MessageExclusive], [Active],[SubscribersQty]) VALUES (23, 4, N'15001-25000', NULL, 145, NULL, NULL, NULL, NULL,25000)		
SET IDENTITY_INSERT [dbo].[UserTypesPlans] OFF