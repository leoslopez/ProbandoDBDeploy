ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [DF_User_IsValidateOriginSentEmailToAdmin] DEFAULT ((0)) FOR [IsValidateOriginSentEmailToAdmin];

