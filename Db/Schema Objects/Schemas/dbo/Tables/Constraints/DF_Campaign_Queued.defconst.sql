ALTER TABLE [dbo].[Campaign] ADD  CONSTRAINT [DF_Campaign_Queued]  DEFAULT ((0)) FOR [Queued]
GO