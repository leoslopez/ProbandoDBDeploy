﻿ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_State] FOREIGN KEY ([IdState]) REFERENCES [dbo].[State] ([IdState]) ON DELETE NO ACTION ON UPDATE NO ACTION;

