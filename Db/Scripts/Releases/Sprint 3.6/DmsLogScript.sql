SET IDENTITY_INSERT [dbo].[AdminSection] ON
 INSERT INTO [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (27, 'DMS-Log', 1)
 INSERT INTO [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (28, 'DMS-LogExplorer', 1)
SET IDENTITY_INSERT [dbo].[AdminSection] OFF
GO

INSERT INTO dbo.AdminAccessRight VALUES (1, 27, 25, '2013-07-10 12:22:00.000')
INSERT INTO dbo.AdminAccessRight VALUES (1, 28, 25, '2013-07-10 12:22:00.000')