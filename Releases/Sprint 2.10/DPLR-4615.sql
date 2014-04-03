CREATE TABLE [dbo].[AdminAccessRight] (
    [IdAdmin]        INT      NOT NULL,
    [IdSection]       INT      NOT NULL,
    [AccessLevel]     INT      NOT NULL,
    [UTCCreationDate] DATETIME NOT NULL
);

CREATE TABLE [dbo].[AdminSection] (
    [IdSection] INT          IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (50) NOT NULL,
    [Active]    BIT          NOT NULL
);

ALTER TABLE [dbo].[AdminAccessRight]
    ADD CONSTRAINT [PK_AdminAccessRight] PRIMARY KEY CLUSTERED ([IdAdmin] ASC, [IdSection] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

ALTER TABLE [dbo].[AdminSection]
    ADD CONSTRAINT [PK_AdminSection] PRIMARY KEY CLUSTERED ([IdSection] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

ALTER TABLE [dbo].[AdminAccessRight]
    ADD CONSTRAINT [FK_AdminAccessRight_Admin] FOREIGN KEY ([IdAdmin]) REFERENCES [dbo].[Admin] ([IdAdmin]) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE [dbo].[AdminAccessRight]
    ADD CONSTRAINT [FK_AdminAccessRight_AdminSection] FOREIGN KEY ([IdSection]) REFERENCES [dbo].[AdminSection] ([IdSection]) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE [dbo].[ViewerAccessRightXUser] 
DROP CONSTRAINT [PK_ViewerAccessRightXUser]
GO

ALTER TABLE [dbo].[ViewerAccessRightXUser]
ADD CONSTRAINT [PK_ViewerAccessRightXUser] PRIMARY KEY CLUSTERED ([IdViewer] ASC, [IdUser] ASC, [IdSection] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
GO

SET IDENTITY_INSERT [dbo].[AdminSection] ON
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (1, N'Clients-Clients List', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (2, N'Clients-Footer', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (3, N'Clients-Global Login', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (4, N'Clients-Clients Blocked', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (5, N'Clients-Individual Billing Not Payed', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (6, N'Clients-Subscribers Billing Not Payed', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (7, N'Clients-Monthly Billing Not Payed', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (8, N'Clients-Domain Keys Pending To Activate', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (9, N'Client Managers-Client Managers List', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (10, N'Client Managers-Changes History', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (11, N'Campaigns - Campaigns List', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (12, N'Templates', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (13, N'Promotion Codes', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (14, N'Customer Billings-Transactions', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (15, N'Customer Billings-File Administration', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (16, N'Customer Billings-Client Invoices Not Payed', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (17, N'Customer Billings-Clients History', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (18, N'Customer Billings-Reports', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (19, N'Reports-Incomplete Registration', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (20, N'Reports-Upgraded Clients List', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (21, N'Reports-Payed Clients List', 1)
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (22, N'Reports-Amount Monthly Created Clients', 1)
SET IDENTITY_INSERT [dbo].[AdminSection] OFF
