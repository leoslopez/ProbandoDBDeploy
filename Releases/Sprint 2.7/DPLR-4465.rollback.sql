-- ALTERS TABLE TO SUPPORT THE NEW LENGTH
ALTER TABLE [User]
ALTER COLUMN [AnswerSecurityQuestion] VARCHAR(100) NULL;
GO