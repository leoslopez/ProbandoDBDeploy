ALTER TABLE [dbo].[SocialNetworkShareXUser]
    ADD CONSTRAINT [FK_SocialNetworkShareXUser_SocialNetwork] FOREIGN KEY ([IdSocialNetwork]) REFERENCES [dbo].[SocialNetwork] ([IdSocialNetwork]) ON DELETE NO ACTION ON UPDATE NO ACTION;

