ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_SecurityQuestion] FOREIGN KEY ([IdSecurityQuestion]) REFERENCES [dbo].[SecurityQuestion] ([IdSecurityQuestion]) ON DELETE NO ACTION ON UPDATE NO ACTION;

