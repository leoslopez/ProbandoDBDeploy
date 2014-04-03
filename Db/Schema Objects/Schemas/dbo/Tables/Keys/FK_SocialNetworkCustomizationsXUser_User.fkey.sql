ALTER TABLE [dbo].[SocialNetworkCustomizationsXUser]
    ADD CONSTRAINT [FK_SocialNetworkCustomizationsXUser_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;

