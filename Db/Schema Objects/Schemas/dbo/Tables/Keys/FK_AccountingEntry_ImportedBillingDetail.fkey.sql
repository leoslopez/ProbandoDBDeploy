ALTER TABLE [dbo].[AccountingEntry]
    ADD CONSTRAINT [FK_AccountingEntry_ImportedBillingDetail] FOREIGN KEY ([IdBillingSource]) REFERENCES [dbo].[ImportedBillingDetail] ([IdImportedBillingDetail]) ON DELETE NO ACTION ON UPDATE NO ACTION;

