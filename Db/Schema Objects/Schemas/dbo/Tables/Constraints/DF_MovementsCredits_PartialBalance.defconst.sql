ALTER TABLE [dbo].[MovementsCredits]
    ADD CONSTRAINT [DF_MovementsCredits_PartialBalance] DEFAULT ((0)) FOR [PartialBalance];

