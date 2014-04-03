ALTER TABLE [dbo].[ConsumerTypes]
    ADD CONSTRAINT [FK_ConsumerTypes_Country] FOREIGN KEY ([IdCountry]) REFERENCES [dbo].[Country] ([IdCountry]) ON DELETE NO ACTION ON UPDATE NO ACTION;

