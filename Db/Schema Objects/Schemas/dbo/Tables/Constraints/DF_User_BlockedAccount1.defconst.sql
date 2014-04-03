ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [DF_User_BlockedAccount1] DEFAULT ((0)) FOR [BlockedAccountNotPayed];

