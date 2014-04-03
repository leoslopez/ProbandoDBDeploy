ALTER TABLE [dbo].[Subscriber]
    ADD CONSTRAINT [FK_Subscriber_Country] FOREIGN KEY ([IdCountry]) REFERENCES [dbo].[Country] ([IdCountry]) ON DELETE NO ACTION ON UPDATE NO ACTION;

