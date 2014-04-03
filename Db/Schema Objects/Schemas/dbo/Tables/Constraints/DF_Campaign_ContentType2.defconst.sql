ALTER TABLE [dbo].[Campaign]
    ADD CONSTRAINT [DF_Campaign_ContentType2] DEFAULT ((1)) FOR [ContentType];

