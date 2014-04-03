ALTER TABLE [dbo].[BlackListDomain]
    ADD CONSTRAINT [DF_BlackListDomain_Marked2] DEFAULT ((0)) FOR [Marked];

