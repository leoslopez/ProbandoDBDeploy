ALTER TABLE [dbo].[AccountingEntry]
    ADD CONSTRAINT [FK_AccountingEntry_AccountingEntry] FOREIGN KEY ([IdInvoice]) REFERENCES [dbo].[AccountingEntry] ([IdAccountingEntry]) ON DELETE NO ACTION ON UPDATE NO ACTION;
	