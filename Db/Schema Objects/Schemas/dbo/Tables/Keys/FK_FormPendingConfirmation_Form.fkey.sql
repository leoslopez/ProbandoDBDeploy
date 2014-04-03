ALTER TABLE [dbo].[FormPendingConfirmation]
    ADD CONSTRAINT [FK_FormPendingConfirmation_Form] FOREIGN KEY ([IdForm]) REFERENCES [dbo].[Form] ([IdForm]) ON DELETE SET NULL ON UPDATE NO ACTION;

