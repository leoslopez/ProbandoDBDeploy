ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [DF_User_IsMaxSubscribersExceedSentEmailToAdmin] DEFAULT ((0)) FOR [IsMaxSubscribersExceedSentEmailToAdmin];



