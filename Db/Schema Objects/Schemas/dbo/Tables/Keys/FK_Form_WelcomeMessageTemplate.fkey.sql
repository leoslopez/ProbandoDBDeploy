ALTER TABLE [dbo].[Form]
    ADD CONSTRAINT [FK_Form_WelcomeMessageTemplate] FOREIGN KEY ([IdWelcomeMessage]) REFERENCES [dbo].[MessageTemplate] ([IdMessageTemplate]) ON DELETE NO ACTION ON UPDATE NO ACTION;

