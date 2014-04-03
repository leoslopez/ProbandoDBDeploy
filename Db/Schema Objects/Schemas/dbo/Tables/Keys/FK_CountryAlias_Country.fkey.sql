ALTER TABLE [dbo].[CountryAlias]
    ADD CONSTRAINT [FK_CountryAlias_Country] FOREIGN KEY ([IdCountry]) REFERENCES [dbo].[Country] ([IdCountry]) ON DELETE NO ACTION ON UPDATE NO ACTION;

