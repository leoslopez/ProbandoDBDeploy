ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_Language] FOREIGN KEY ([IdLanguage]) REFERENCES [dbo].[Language] ([IdLanguage]) ON DELETE NO ACTION ON UPDATE NO ACTION;

