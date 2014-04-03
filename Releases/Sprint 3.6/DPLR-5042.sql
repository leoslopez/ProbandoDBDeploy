ALTER TABLE dbo.BlacklistEntry
ADD AdminApproved INT NULL,
	UploadedDate DATETIME NULL,
	EntryStatus INT NOT NULL,
	Ip nvarchar(15) NULL
	GO
	
SET IDENTITY_INSERT [dbo].[AdminSection] ON
	INSERT INTO [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (24, 'Clients-Blacklist Users', 1)
	INSERT INTO [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (25, 'Clients-AcceptBlackListEntry', 1)
SET IDENTITY_INSERT [dbo].[AdminSection] OFF
GO

INSERT INTO dbo.AdminAccessRight VALUES (1, 24, 25, '2013-07-10 12:22:00.000')
INSERT INTO dbo.AdminAccessRight VALUES (1, 25, 25, '2013-07-10 12:22:00.000')
GO

INSERT INTO dbo.BlackListSource VALUES ('AbuseForm')
GO

UPDATE dbo.BlackListEntry SET EntryStatus = 1
