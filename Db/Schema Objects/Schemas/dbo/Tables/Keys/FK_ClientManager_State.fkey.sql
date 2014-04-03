ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_State] FOREIGN KEY ([IdState]) REFERENCES [dbo].[State] ([IdState]) ON DELETE NO ACTION ON UPDATE NO ACTION;

