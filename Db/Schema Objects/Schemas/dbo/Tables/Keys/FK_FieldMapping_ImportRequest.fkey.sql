ALTER TABLE [dbo].[FieldMapping]
    ADD CONSTRAINT [FK_FieldMapping_ImportRequest] FOREIGN KEY ([IdImportRequest]) REFERENCES [dbo].[ImportRequest] ([IdImportRequest]) ON DELETE NO ACTION ON UPDATE NO ACTION;

