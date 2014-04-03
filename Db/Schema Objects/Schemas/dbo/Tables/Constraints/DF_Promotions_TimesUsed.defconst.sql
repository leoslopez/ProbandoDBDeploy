ALTER TABLE [dbo].[Promotions]
    ADD CONSTRAINT [DF_Promotions_TimesUsed] DEFAULT ((0)) FOR [TimesUsed];

