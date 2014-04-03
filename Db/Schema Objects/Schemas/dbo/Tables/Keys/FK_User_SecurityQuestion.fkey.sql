ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_SecurityQuestion] FOREIGN KEY ([IdSecurityQuestion]) REFERENCES [dbo].[SecurityQuestion] ([IdSecurityQuestion]) ON DELETE NO ACTION ON UPDATE NO ACTION;

