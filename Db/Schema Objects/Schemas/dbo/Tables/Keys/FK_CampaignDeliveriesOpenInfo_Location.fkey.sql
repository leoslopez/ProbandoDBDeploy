ALTER TABLE [dbo].[CampaignDeliveriesOpenInfo]  
	ADD CONSTRAINT [FK_CampaignDeliveriesOpenInfo_Location] FOREIGN KEY([LocId]) REFERENCES [dbo].[Location] ([LocId]);