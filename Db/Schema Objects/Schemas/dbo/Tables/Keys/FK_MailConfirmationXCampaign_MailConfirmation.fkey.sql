ALTER TABLE [dbo].[MailConfirmationXCampaign]
    ADD CONSTRAINT [FK_MailConfirmationXCampaign_MailConfirmation] FOREIGN KEY ([IdMailConfirmation]) REFERENCES [dbo].[MailConfirmation] ([IdMailConfirmation]) ON DELETE NO ACTION ON UPDATE NO ACTION;

