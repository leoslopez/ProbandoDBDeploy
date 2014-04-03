-- =============================================
-- Script Template
-- =============================================

ALTER TABLE dbo.[User]
 ADD [IsRegistrationCompleted] BIT DEFAULT ((0)) NOT NULL

 GO

ALTER TABLE dbo.[User]
 ADD [UTCRegistrationCompleted] DATETIME NULL

 GO

 UPDATE dbo.[User] SET [IsRegistrationCompleted] = 1 WHERE AccountValidation = 1