ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_UserTimeZone] FOREIGN KEY ([IdTimeZone]) REFERENCES [dbo].[UserTimeZone] ([IdUserTimeZone]) ON DELETE NO ACTION ON UPDATE NO ACTION;

