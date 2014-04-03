ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_PaymentMethods] FOREIGN KEY ([IdPaymentMethod]) REFERENCES [dbo].[PaymentMethods] ([IdPaymentMethod]) ON DELETE NO ACTION ON UPDATE NO ACTION;

