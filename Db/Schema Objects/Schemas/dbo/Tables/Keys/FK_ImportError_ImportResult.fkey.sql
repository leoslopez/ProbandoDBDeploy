ALTER TABLE [dbo].[ImportError]
    ADD CONSTRAINT [FK_ImportError_ImportResult] FOREIGN KEY ([IdImportResult]) REFERENCES [dbo].[ImportResult] ([IdImportResult]) ON DELETE NO ACTION ON UPDATE NO ACTION;

