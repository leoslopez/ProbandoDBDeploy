ALTER TABLE [dbo].[MessageTemplate]
    ADD CONSTRAINT [FK_ConfirmationTemplate_ConfirmationTemplate1] FOREIGN KEY ([ParentTemplate]) REFERENCES [dbo].[MessageTemplate] ([IdMessageTemplate]) ON DELETE NO ACTION ON UPDATE NO ACTION;

