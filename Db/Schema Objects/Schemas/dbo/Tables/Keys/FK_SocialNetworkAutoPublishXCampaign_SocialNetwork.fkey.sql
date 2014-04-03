ALTER TABLE [dbo].[SocialNetworkAutoPublishXCampaign]
    ADD CONSTRAINT [FK_SocialNetworkAutoPublishXCampaign_SocialNetwork] FOREIGN KEY ([IdSocialNetwork]) REFERENCES [dbo].[SocialNetwork] ([IdSocialNetwork]) ON DELETE NO ACTION ON UPDATE NO ACTION;

