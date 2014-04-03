ALTER TABLE [dbo].[SocialNetworkShareXCampaign]
    ADD CONSTRAINT [FK_SocialNetworkXCampaign_SocialNetwork] FOREIGN KEY ([IdSocialNetwork]) REFERENCES [dbo].[SocialNetwork] ([IdSocialNetwork]) ON DELETE NO ACTION ON UPDATE NO ACTION;

