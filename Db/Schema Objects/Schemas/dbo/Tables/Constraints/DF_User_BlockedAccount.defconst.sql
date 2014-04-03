ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [DF_User_BlockedAccount] DEFAULT ((0)) FOR [BlockedAccountInvalidPassword];



