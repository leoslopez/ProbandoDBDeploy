ALTER TABLE dbo.BillingCredits
ADD NroFacturacion varchar(250) NULL

SET IDENTITY_INSERT [dbo].[AdminSection] ON
	INSERT INTO [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (26, 'Reports-BillingRequests', 1)
SET IDENTITY_INSERT [dbo].[AdminSection] OFF
GO

INSERT INTO dbo.AdminAccessRight VALUES (1, 26, 25, '2013-07-10 12:22:00.000')