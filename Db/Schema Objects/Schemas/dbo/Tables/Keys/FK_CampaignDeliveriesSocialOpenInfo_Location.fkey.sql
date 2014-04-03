ALTER TABLE [dbo].[CampaignDeliveriesSocialOpenInfo]  
	ADD  CONSTRAINT [FK_CampaignDeliveriesSocialOpenInfo_Location] FOREIGN KEY([LocId]) REFERENCES [dbo].[Location] ([LocId]);