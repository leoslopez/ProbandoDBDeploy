ALTER TABLE [dbo].[Viewer]
    ADD CONSTRAINT [FK_Viewer_SecurityQuestion] FOREIGN KEY ([IdSecurityQuestion]) REFERENCES [dbo].[SecurityQuestion] ([IdSecurityQuestion]) ON DELETE NO ACTION ON UPDATE NO ACTION;

