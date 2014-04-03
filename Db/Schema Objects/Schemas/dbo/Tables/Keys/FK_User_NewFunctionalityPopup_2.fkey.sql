ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_NewFunctionalityPopup] FOREIGN KEY ([IdNewFunctionalityPopup]) REFERENCES [dbo].[NewFunctionalityPopup] ([IdNewFunctionalityPopup]) ON DELETE NO ACTION ON UPDATE NO ACTION;

