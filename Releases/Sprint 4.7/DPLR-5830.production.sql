PRINT 'Create [AccountCancellationReason] table'
CREATE TABLE [dbo].[AccountCancellationReason]
(
	[IdAccountCancellationReason]	INT		IDENTITY (1, 1)		NOT NULL,
    [IdResource]					INT							NOT NULL
)

GO

PRINT 'Create [PK_AccountCancellationReason]'
ALTER TABLE [dbo].[AccountCancellationReason]
    ADD CONSTRAINT [PK_AccountCancellationReason] PRIMARY KEY CLUSTERED ([IdAccountCancellationReason] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
    
GO

PRINT 'Create [FK_AccountCancellationReason_Resource]'
ALTER TABLE [dbo].[AccountCancellationReason]
    ADD CONSTRAINT [FK_AccountCancellationReason_Resource] FOREIGN KEY ([IdResource]) REFERENCES [dbo].[Resource] ([IdResource]) ON DELETE NO ACTION ON UPDATE NO ACTION;

GO

PRINT 'Insert values into [Resource] table'
SET IDENTITY_INSERT [dbo].[Resource] ON
INSERT [dbo].[Resource] ([IdResource], [DescriptionEs], [DescriptionEn]) VALUES (8, N'Falta de pago / No contesta', N'Falta de pago / No contesta')
INSERT [dbo].[Resource] ([IdResource], [DescriptionEs], [DescriptionEn]) VALUES (9, N'Falta de pago / No usa mas el servicio', N'Falta de pago / No usa mas el servicio')
INSERT [dbo].[Resource] ([IdResource], [DescriptionEs], [DescriptionEn]) VALUES (10, N'Falta de pago / Contrato otro servicio', N'Falta de pago / Contrato otro servicio')
INSERT [dbo].[Resource] ([IdResource], [DescriptionEs], [DescriptionEn]) VALUES (11, N'Cancela el sevicio / No hace mas email Marketing', N'Cancela el sevicio / No hace mas email Marketing')
INSERT [dbo].[Resource] ([IdResource], [DescriptionEs], [DescriptionEn]) VALUES (12, N'Cancela el servicio / Doppler no cumple sus expectativas - contrato otro servicio', N'Cancela el servicio / Doppler no cumple sus expectativas - contrato otro servicio')
INSERT [dbo].[Resource] ([IdResource], [DescriptionEs], [DescriptionEn]) VALUES (13, N'Cancela el servicio / Falta de respuesta a sus problemas - contrato otro servicio', N'Cancela el servicio / Falta de respuesta a sus problemas - contrato otro servicio')
INSERT [dbo].[Resource] ([IdResource], [DescriptionEs], [DescriptionEn]) VALUES (14, N'Cancela el servicio / Doppler resulto un precio caro', N'Cancela el servicio / Doppler resulto un precio caro')
INSERT [dbo].[Resource] ([IdResource], [DescriptionEs], [DescriptionEn]) VALUES (15, N'Cancela el servicio / Cliente Dudoso por SPAMMER/PISHING', N'Cancela el servicio / Cliente Dudoso por SPAMMER/PISHING')
INSERT [dbo].[Resource] ([IdResource], [DescriptionEs], [DescriptionEn]) VALUES (16, N'Cancela el servicio / No usa mas el servicio', N'Cancela el servicio / No usa mas el servicio')
INSERT [dbo].[Resource] ([IdResource], [DescriptionEs], [DescriptionEn]) VALUES (17, N'Cancela el servicio / Contrato otro servicio', N'Cancela el servicio / Contrato otro servicio')
INSERT [dbo].[Resource] ([IdResource], [DescriptionEs], [DescriptionEn]) VALUES (18, N'Cancela el servicio / Contrata con otra cuenta', N'Cancela el servicio / Contrata con otra cuenta')
SET IDENTITY_INSERT [dbo].[Resource] OFF

GO

PRINT 'Insert values into [AccountCancellationReason] table'
SET IDENTITY_INSERT [dbo].[AccountCancellationReason] ON
INSERT [dbo].[AccountCancellationReason] ([IdAccountCancellationReason], [IdResource]) VALUES (1, 8)
INSERT [dbo].[AccountCancellationReason] ([IdAccountCancellationReason], [IdResource]) VALUES (2, 9)
INSERT [dbo].[AccountCancellationReason] ([IdAccountCancellationReason], [IdResource]) VALUES (3, 10)
INSERT [dbo].[AccountCancellationReason] ([IdAccountCancellationReason], [IdResource]) VALUES (4, 11)
INSERT [dbo].[AccountCancellationReason] ([IdAccountCancellationReason], [IdResource]) VALUES (5, 12)
INSERT [dbo].[AccountCancellationReason] ([IdAccountCancellationReason], [IdResource]) VALUES (6, 13)
INSERT [dbo].[AccountCancellationReason] ([IdAccountCancellationReason], [IdResource]) VALUES (7, 14)
INSERT [dbo].[AccountCancellationReason] ([IdAccountCancellationReason], [IdResource]) VALUES (8, 15)
INSERT [dbo].[AccountCancellationReason] ([IdAccountCancellationReason], [IdResource]) VALUES (9, 16)
INSERT [dbo].[AccountCancellationReason] ([IdAccountCancellationReason], [IdResource]) VALUES (10, 17)
INSERT [dbo].[AccountCancellationReason] ([IdAccountCancellationReason], [IdResource]) VALUES (11, 18)
SET IDENTITY_INSERT [dbo].[AccountCancellationReason] OFF

GO

PRINT 'Alter [IdAccountCancellationReason] column into [User] table'
ALTER TABLE [dbo].[User] ADD [IdAccountCancellationReason] INT NULL
GO

PRINT 'Create [FK_User_AccountCancellationReason]'
ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_AccountCancellationReason] FOREIGN KEY ([IdAccountCancellationReason]) REFERENCES [dbo].[AccountCancellationReason] ([IdAccountCancellationReason]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

PRINT 'Create UpdateCampaignStatusForCanceledAccount stored procedure'
GO
CREATE PROCEDURE UpdateCampaignStatusForCanceledAccount @IdUser INT
AS
BEGIN
	-- update status for campaigns in status ON_HOLD = 2, VERIFY_CREDITS = 3, SCHEDULED = 4, ANALIZE_SEGMENT = 7, READY_TO_VERIFY = 8
	UPDATE [dbo].[Campaign] 
		SET status = 1 
		WHERE IdUser = @IdUser AND IdTestAB IS NULL AND status IN (2, 3, 4, 7, 8)
	
	-- update status for TEST AB campaigns when tests were not sent yet
	UPDATE CR
		SET CR.status = 11 
		FROM Campaign CR
			INNER JOIN Campaign CA ON(CR.IdTestAB = CA.IdTestAB)
			INNER JOIN Campaign CB ON(CR.IdTestAB = CB.IdTestAB)
		WHERE CR.IdUser = @IdUser
		AND CR.IdTestAB IS NOT NULL
		AND CR.TestABCategory = 3 AND CR.status = 17
		AND CA.TestABCategory = 1 AND CA.Status = 11
		AND CB.TestABCategory = 2 AND CB.Status = 11
END

GO
PRINT 'Insert into [AdminSection] table the new section: Reports-Canceled Accounts'
SET IDENTITY_INSERT [dbo].[AdminSection] ON
INSERT [dbo].[AdminSection] ([IdSection], [Name], [Active]) VALUES (29, N'Reports-Canceled Accounts', 1)
SET IDENTITY_INSERT [dbo].[AdminSection] OFF

GO
PRINT 'Insert into [AdminAccessRight] table the new section access right: Reports-Canceled Accounts'
INSERT [dbo].[AdminAccessRight] ([IdAdmin], [IdSection], [AccessLevel], [UTCCreationDate]) VALUES (1, 29, 25, CAST(0x0000A1E000E83E79 AS DateTime))