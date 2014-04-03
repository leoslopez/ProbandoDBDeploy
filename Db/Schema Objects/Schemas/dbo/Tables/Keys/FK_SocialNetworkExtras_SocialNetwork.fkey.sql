ALTER TABLE [dbo].[SocialNetworkExtras]
    ADD CONSTRAINT [FK_SocialNetworkExtras_SocialNetwork] FOREIGN KEY ([IdSocialNetwork]) REFERENCES [dbo].[SocialNetwork] ([IdSocialNetwork]) ON DELETE NO ACTION ON UPDATE NO ACTION;

