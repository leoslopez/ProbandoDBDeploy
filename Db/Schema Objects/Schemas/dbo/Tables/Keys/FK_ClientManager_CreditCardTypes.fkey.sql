ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_CreditCardTypes] FOREIGN KEY ([IdCCType]) REFERENCES [dbo].[CreditCardTypes] ([IdCCType]) ON DELETE NO ACTION ON UPDATE NO ACTION;

