ALTER TABLE [dbo].[ContentXField]
    ADD CONSTRAINT [FK_ContentXField_Field] FOREIGN KEY ([IdField]) REFERENCES [dbo].[Field] ([IdField]) ON DELETE NO ACTION ON UPDATE NO ACTION;

