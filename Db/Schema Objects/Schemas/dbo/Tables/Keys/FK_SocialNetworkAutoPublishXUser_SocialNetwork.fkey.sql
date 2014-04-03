ALTER TABLE [dbo].[SocialNetworkAutoPublishXUser]
    ADD CONSTRAINT [FK_SocialNetworkAutoPublishXUser_SocialNetwork] FOREIGN KEY ([IdSocialNetwork]) REFERENCES [dbo].[SocialNetwork] ([IdSocialNetwork]) ON DELETE NO ACTION ON UPDATE NO ACTION;

