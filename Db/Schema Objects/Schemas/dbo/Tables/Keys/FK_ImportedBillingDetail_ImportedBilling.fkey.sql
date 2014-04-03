ALTER TABLE [dbo].[ImportedBillingDetail]
    ADD CONSTRAINT [FK_ImportedBillingDetail_ImportedBilling] FOREIGN KEY ([IdImportedBilling]) REFERENCES [dbo].[ImportedBilling] ([IdImportedBilling]) ON DELETE NO ACTION ON UPDATE NO ACTION;

