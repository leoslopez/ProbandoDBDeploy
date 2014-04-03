ALTER TABLE [dbo].[DomainKeyInformation]
    ADD CONSTRAINT [FK_DomainKeyInformation_State] FOREIGN KEY ([IdState]) REFERENCES [dbo].[State] ([IdState]) ON DELETE NO ACTION ON UPDATE NO ACTION;

