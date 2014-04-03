ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_ResponsabileBilling] FOREIGN KEY ([IdResponsabileBilling]) REFERENCES [dbo].[ResponsabileBilling] ([IdResponsabileBilling]) ON DELETE NO ACTION ON UPDATE NO ACTION;

