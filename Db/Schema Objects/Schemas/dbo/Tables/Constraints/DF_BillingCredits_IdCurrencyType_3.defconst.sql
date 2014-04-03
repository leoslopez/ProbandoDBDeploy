ALTER TABLE [dbo].[BillingCredits]
    ADD CONSTRAINT [DF_BillingCredits_IdCurrencyType] DEFAULT ((0)) FOR [IdCurrencyType];

