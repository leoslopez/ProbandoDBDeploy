ALTER TABLE [dbo].[Form]
    ADD CONSTRAINT [FK_Form_ConfirmationMessageTemplate] FOREIGN KEY ([IdConfirmationMessage]) REFERENCES [dbo].[MessageTemplate] ([IdMessageTemplate]) ON DELETE NO ACTION ON UPDATE NO ACTION;

