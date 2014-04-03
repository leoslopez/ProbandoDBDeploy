ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_AmounMonthlyEmails] FOREIGN KEY ([IdAmountMonthlyEmails]) REFERENCES [dbo].[AmountMonthlyEmails] ([IdAmountMonthlyEmails]) ON DELETE NO ACTION ON UPDATE NO ACTION;

