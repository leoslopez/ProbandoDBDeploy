﻿ALTER TABLE [dbo].[SocialNetworkAutoPublishXUser]
    ADD CONSTRAINT [FK_SocialNetworkXUser_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;
