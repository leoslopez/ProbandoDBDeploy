ALTER TABLE [dbo].[Platforms]
    ADD CONSTRAINT [FK_Platforms_IdPlatformType] FOREIGN KEY ([IdPlatformType]) REFERENCES [dbo].[PlatformTypes] ([IdPlatformType]) ON DELETE NO ACTION ON UPDATE NO ACTION;

