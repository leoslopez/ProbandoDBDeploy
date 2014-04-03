ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [DF_User_SubscribersLimitExceeded] DEFAULT ((0)) FOR [IsSubscribersLimitExceeded];



