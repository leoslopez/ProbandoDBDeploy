﻿ALTER TABLE [dbo].[Downloads]
    ADD CONSTRAINT [FK_Downloads_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;

