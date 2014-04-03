ALTER TABLE [dbo].[Viewer]
    ADD CONSTRAINT [FK_Viewer_ClientManager] FOREIGN KEY ([IdClientManager]) REFERENCES [dbo].[ClientManager] ([IdClientManager]) ON DELETE NO ACTION ON UPDATE NO ACTION;

