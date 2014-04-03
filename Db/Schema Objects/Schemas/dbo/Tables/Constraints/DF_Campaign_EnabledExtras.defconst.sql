ALTER TABLE [dbo].[Campaign]
    ADD CONSTRAINT [DF_Campaign_EnabledExtras] DEFAULT ((1)) FOR [EnabledExtras];

