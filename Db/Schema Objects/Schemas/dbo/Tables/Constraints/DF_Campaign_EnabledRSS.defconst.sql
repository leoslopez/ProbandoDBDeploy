ALTER TABLE [dbo].[Campaign]
    ADD CONSTRAINT [DF_Campaign_EnabledRSS] DEFAULT ((1)) FOR [EnabledRSS];

