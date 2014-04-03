ALTER TABLE [dbo].[ImportTask]
    ADD CONSTRAINT [FK_ImportTask_ImportRequest] FOREIGN KEY ([IdImportRequest]) REFERENCES [dbo].[ImportRequest] ([IdImportRequest]) ON DELETE NO ACTION ON UPDATE NO ACTION;

