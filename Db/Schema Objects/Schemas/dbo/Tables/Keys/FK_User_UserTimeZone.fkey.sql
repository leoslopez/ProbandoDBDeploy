ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_UserTimeZone] FOREIGN KEY ([IdUserTimeZone]) REFERENCES [dbo].[UserTimeZone] ([IdUserTimeZone]) ON DELETE NO ACTION ON UPDATE NO ACTION;

