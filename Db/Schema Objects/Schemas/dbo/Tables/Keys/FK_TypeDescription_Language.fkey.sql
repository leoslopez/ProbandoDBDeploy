ALTER TABLE [dbo].[TypeDescription]
    ADD CONSTRAINT [FK_TypeDescription_Language] FOREIGN KEY ([IdLanguage]) REFERENCES [dbo].[Language] ([IdLanguage]) ON DELETE NO ACTION ON UPDATE NO ACTION;

