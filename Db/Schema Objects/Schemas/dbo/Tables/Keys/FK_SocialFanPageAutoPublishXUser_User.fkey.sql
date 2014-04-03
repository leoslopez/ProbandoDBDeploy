ALTER TABLE [dbo].[SocialFanPageAutoPublishXUser]
    ADD CONSTRAINT [FK_SocialFanPageAutoPublishXUser_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;

