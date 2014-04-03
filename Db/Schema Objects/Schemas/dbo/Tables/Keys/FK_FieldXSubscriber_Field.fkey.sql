ALTER TABLE [dbo].[FieldXSubscriber]
    ADD CONSTRAINT [FK_FieldXSubscriber_Field] FOREIGN KEY ([IdField]) REFERENCES [dbo].[Field] ([IdField]) ON DELETE CASCADE ON UPDATE NO ACTION;

