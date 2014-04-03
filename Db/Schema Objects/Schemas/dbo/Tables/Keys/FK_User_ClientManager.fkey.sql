ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_ClientManager] FOREIGN KEY ([IdClientManager]) REFERENCES [dbo].[ClientManager] ([IdClientManager]) ON DELETE NO ACTION ON UPDATE NO ACTION;

