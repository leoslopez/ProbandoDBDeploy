ALTER TABLE [dbo].[MovementsCredits]
    ADD CONSTRAINT [FK_BillingCredits_MovementsCredits] FOREIGN KEY ([IdBillingCredit]) REFERENCES [dbo].[BillingCredits] ([IdBillingCredit]) ON DELETE NO ACTION ON UPDATE NO ACTION;





