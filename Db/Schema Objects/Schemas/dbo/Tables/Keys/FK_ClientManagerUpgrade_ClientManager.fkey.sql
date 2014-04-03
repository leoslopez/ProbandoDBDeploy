ALTER TABLE [dbo].[ClientManagerUpgrade]
    ADD CONSTRAINT [FK_ClientManagerUpgrade_ClientManager] FOREIGN KEY ([IdClientManager]) REFERENCES [dbo].[ClientManager] ([IdClientManager]) ON DELETE NO ACTION ON UPDATE NO ACTION;

