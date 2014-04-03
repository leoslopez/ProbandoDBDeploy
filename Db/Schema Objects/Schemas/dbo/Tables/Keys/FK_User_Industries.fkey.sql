ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_Industries] FOREIGN KEY ([IdIndustry]) REFERENCES [dbo].[Industry] ([IdIndustry]) ON DELETE NO ACTION ON UPDATE NO ACTION;

