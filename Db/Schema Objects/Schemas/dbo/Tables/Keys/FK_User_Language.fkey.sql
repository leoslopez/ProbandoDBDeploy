ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_Language] FOREIGN KEY ([IdLanguage]) REFERENCES [dbo].[Language] ([IdLanguage]) ON DELETE NO ACTION ON UPDATE NO ACTION;

