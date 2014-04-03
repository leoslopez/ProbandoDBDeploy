-- =============================================
-- Script Template
-- =============================================
GO

ALTER TABLE [dbo].[Content]
	ADD [IsPlainTextUpdated] BIT DEFAULT ((0)) NOT NULL

GO

UPDATE [Content] SET [IsPlainTextUpdated] = 1 WHERE PlainText is not null

