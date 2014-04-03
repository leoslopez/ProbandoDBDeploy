ALTER TABLE [dbo].[Promotions]
    ADD CONSTRAINT [DF_Promotions_active] DEFAULT ((1)) FOR [Active];

