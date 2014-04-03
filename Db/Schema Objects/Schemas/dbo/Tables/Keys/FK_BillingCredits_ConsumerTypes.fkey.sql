ALTER TABLE [dbo].[BillingCredits]
    ADD CONSTRAINT [FK_BillingCredits_ConsumerTypes] FOREIGN KEY ([IdConsumerType]) REFERENCES [dbo].ConsumerTypes ([IdConsumerType]) ON DELETE NO ACTION ON UPDATE NO ACTION;





