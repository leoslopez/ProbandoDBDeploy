ALTER TABLE [dbo].[Campaign]
    ADD CONSTRAINT [DF_Campaign_Status] DEFAULT ('0') FOR [Status];

