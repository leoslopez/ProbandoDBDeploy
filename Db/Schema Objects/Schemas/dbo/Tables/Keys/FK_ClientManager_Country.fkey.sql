ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_Country] FOREIGN KEY ([IdCountry]) REFERENCES [dbo].[Country] ([IdCountry]) ON DELETE NO ACTION ON UPDATE NO ACTION;

