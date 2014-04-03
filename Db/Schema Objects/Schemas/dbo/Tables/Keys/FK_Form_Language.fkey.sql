ALTER TABLE [dbo].[Form]
    ADD CONSTRAINT [FK_Form_Language] FOREIGN KEY ([IdMailTemplatesLanguage]) REFERENCES [dbo].[Language] ([IdLanguage]) ON DELETE NO ACTION ON UPDATE NO ACTION;

