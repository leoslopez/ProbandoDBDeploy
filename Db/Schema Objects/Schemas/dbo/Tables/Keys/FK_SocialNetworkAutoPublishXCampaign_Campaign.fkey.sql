ALTER TABLE [dbo].[SocialNetworkAutoPublishXCampaign]
    ADD CONSTRAINT [FK_SocialNetworkAutoPublishXCampaign_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE NO ACTION ON UPDATE NO ACTION;

