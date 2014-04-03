ALTER TABLE [dbo].[SocialNetworkExtrasXCampaign]
    ADD CONSTRAINT [FK_SocialNetworkExtrasXCampaign_SocialNetworkExtras] FOREIGN KEY ([IdExtra]) REFERENCES [dbo].[SocialNetworkExtras] ([IdExtra]) ON DELETE NO ACTION ON UPDATE NO ACTION;

