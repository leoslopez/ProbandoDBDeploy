ALTER TABLE [dbo].[MailConfirmation]
    ADD CONSTRAINT [FK_MailConfirmationList_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;

