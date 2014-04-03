ALTER TABLE [dbo].[BlackListSource]
    ADD CONSTRAINT [DF_BlackListSource_CanBeRevived] DEFAULT ((0)) FOR [CanBeRevived];

