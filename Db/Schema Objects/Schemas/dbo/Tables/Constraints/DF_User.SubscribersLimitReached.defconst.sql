ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [DF_User_SubscribersLimitReached] DEFAULT ((0)) FOR [IsSubscribersLimitReached];


GO