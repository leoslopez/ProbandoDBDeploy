ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_BillingCredits] FOREIGN KEY ([IdCurrentBillingCredit]) REFERENCES [dbo].[BillingCredits] ([IdBillingCredit]) ON DELETE NO ACTION ON UPDATE NO ACTION;

