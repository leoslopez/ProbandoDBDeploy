ALTER TABLE [dbo].[MailConfirmationXCampaign]
    ADD CONSTRAINT [FK_ConfirmationMailXCampaign_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE CASCADE ON UPDATE NO ACTION;

