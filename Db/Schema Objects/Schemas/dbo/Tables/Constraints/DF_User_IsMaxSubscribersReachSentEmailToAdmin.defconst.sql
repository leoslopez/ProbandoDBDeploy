ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [DF_User_IsMaxSubscribersReachSentEmailToAdmin] DEFAULT ((0)) FOR [IsMaxSubscribersReachSentEmailToAdmin];



