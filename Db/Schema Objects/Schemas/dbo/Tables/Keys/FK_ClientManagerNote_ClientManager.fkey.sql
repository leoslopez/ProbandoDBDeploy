ALTER TABLE [dbo].[ClientManagerNote]
    ADD CONSTRAINT [FK_ClientManagerNote_ClientManager] FOREIGN KEY ([IdClientManager]) REFERENCES [dbo].[ClientManager] ([IdClientManager]) ON DELETE NO ACTION ON UPDATE NO ACTION;

