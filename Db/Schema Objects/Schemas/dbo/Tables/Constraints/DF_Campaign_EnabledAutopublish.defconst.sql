ALTER TABLE [dbo].[Campaign]
    ADD CONSTRAINT [DF_Campaign_EnabledAutopublish] DEFAULT ((1)) FOR [EnabledAutopublish];

