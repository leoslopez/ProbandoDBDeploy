ALTER TABLE [dbo].[FieldMapping]
    ADD CONSTRAINT [FK_FieldMapping_Field] FOREIGN KEY ([IdField]) REFERENCES [dbo].[Field] ([IdField]) ON DELETE NO ACTION ON UPDATE NO ACTION;

