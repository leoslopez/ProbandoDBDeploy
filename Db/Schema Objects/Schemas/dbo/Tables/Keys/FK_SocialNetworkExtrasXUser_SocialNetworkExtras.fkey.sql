ALTER TABLE [dbo].[SocialNetworkExtrasXUser]
    ADD CONSTRAINT [FK_SocialNetworkExtrasXUser_SocialNetworkExtras] FOREIGN KEY ([IdExtra]) REFERENCES [dbo].[SocialNetworkExtras] ([IdExtra]) ON DELETE NO ACTION ON UPDATE NO ACTION;

