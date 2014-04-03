ALTER TABLE [dbo].[SocialNetworkExtrasXUser]
    ADD CONSTRAINT [FK_SocialNetworkExtrasXUser_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;

