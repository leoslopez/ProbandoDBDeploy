ALTER TABLE [dbo].[Blocks]  
	ADD  CONSTRAINT [FK_Blocks_Location] FOREIGN KEY([LocId]) REFERENCES [dbo].[Location] ([LocId]);