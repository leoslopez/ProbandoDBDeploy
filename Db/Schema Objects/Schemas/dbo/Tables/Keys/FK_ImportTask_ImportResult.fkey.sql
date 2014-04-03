ALTER TABLE [dbo].[ImportTask]
    ADD CONSTRAINT [FK_ImportTask_ImportResult] FOREIGN KEY ([IdImportResult]) REFERENCES [dbo].[ImportResult] ([IdImportResult]) ON DELETE NO ACTION ON UPDATE NO ACTION;

