ALTER TABLE [dbo].[DomainKeyInformation]
    ADD CONSTRAINT [FK_DomainKeyInformation_Country] FOREIGN KEY ([IdCountry]) REFERENCES [dbo].[Country] ([IdCountry]) ON DELETE NO ACTION ON UPDATE NO ACTION;

