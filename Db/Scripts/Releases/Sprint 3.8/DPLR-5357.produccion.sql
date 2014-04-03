ALTER TABLE [dbo].[ClientManager] ADD [PasswordResetCode] VARCHAR (100) NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [PasswordResetCodeDate] DATETIME NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [AmountAttempsAnswerSecurity]	INT NULL
GO