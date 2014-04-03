ALTER TABLE [dbo].[UserChangesHistory]
    ADD CONSTRAINT [FK_UserChangesHistory_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;

