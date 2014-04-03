ALTER TABLE [dbo].[BlacklistEmail]
    ADD CONSTRAINT [DF_BlackListEmail_Marked2] DEFAULT ((0)) FOR [Marked];

