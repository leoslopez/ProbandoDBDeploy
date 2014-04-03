ALTER TABLE [dbo].[SubscribersListXCampaign]
    ADD CONSTRAINT [FK_SubscribersListXCampaign_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE CASCADE ON UPDATE NO ACTION;

