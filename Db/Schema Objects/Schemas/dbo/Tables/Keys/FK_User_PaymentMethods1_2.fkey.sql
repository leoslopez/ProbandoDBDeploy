ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_PaymentMethods1] FOREIGN KEY ([PaymentMethod]) REFERENCES [dbo].[PaymentMethods] ([IdPaymentMethod]) ON DELETE NO ACTION ON UPDATE NO ACTION;

