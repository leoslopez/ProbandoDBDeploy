ALTER TABLE [dbo].[State]
    ADD CONSTRAINT [FK_State_Country] FOREIGN KEY ([IdCountry]) REFERENCES [dbo].[Country] ([IdCountry]) ON DELETE NO ACTION ON UPDATE NO ACTION;

