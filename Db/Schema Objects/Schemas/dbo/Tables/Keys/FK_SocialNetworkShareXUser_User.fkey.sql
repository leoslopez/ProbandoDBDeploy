ALTER TABLE [dbo].[SocialNetworkShareXUser]
    ADD CONSTRAINT [FK_SocialNetworkShareXUser_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;

