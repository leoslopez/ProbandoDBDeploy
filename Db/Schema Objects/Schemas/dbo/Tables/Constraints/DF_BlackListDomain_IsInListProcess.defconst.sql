ALTER TABLE [dbo].[BlackListDomain]
    ADD CONSTRAINT [DF_BlackListDomain_IsInListProcess] DEFAULT ((0)) FOR [IsInListProcess];

