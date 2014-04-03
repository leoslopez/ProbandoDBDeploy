ALTER TABLE [dbo].[DomainKeyInformation]
    ADD CONSTRAINT [FK_DomainKeyInformation_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;

