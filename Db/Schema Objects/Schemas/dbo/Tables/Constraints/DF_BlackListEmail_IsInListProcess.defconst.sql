ALTER TABLE [dbo].[BlackListEmail]
    ADD CONSTRAINT [DF_BlackListEmail_IsInListProcess] DEFAULT ((0)) FOR [IsInListProcess];

