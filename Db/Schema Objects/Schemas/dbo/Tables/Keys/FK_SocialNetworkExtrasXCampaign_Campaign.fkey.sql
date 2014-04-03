ALTER TABLE [dbo].[SocialNetworkExtrasXCampaign]
    ADD CONSTRAINT [FK_SocialNetworkExtrasXCampaign_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE NO ACTION ON UPDATE NO ACTION;

