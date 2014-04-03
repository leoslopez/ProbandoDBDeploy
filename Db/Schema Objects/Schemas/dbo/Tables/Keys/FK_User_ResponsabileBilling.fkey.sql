ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_ResponsabileBilling] FOREIGN KEY ([IdResponsabileBilling]) REFERENCES [dbo].[ResponsabileBilling] ([IdResponsabileBilling]) ON DELETE NO ACTION ON UPDATE NO ACTION;

