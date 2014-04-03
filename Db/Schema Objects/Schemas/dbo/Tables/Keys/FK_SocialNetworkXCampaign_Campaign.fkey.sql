ALTER TABLE [dbo].[SocialNetworkShareXCampaign]
    ADD CONSTRAINT [FK_SocialNetworkXCampaign_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE NO ACTION ON UPDATE NO ACTION;

