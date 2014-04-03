ALTER TABLE [dbo].[Promotions]
    ADD CONSTRAINT [DF_Promotions_TimesToUse] DEFAULT ((0)) FOR [TimesToUse];

