ALTER TABLE [dbo].[ImportRequest]
    ADD CONSTRAINT [FK_ImportRequest_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;

