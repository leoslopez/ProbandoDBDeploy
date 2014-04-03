ALTER TABLE [dbo].[MaxSubscribersToValidateHistory]
    ADD CONSTRAINT [FK_MaxSubscribersToValidateHistory_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;

