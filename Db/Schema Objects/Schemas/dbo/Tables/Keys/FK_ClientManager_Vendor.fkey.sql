ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_Vendor] FOREIGN KEY ([IdVendor]) REFERENCES [dbo].[Vendor] ([IdVendor]) ON DELETE NO ACTION ON UPDATE NO ACTION;

