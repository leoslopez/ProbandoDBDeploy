﻿ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_CreditCardTypes] FOREIGN KEY ([IdCCType]) REFERENCES [dbo].[CreditCardTypes] ([IdCCType]) ON DELETE NO ACTION ON UPDATE NO ACTION;

