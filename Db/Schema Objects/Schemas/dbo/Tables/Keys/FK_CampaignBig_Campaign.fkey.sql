ALTER TABLE [dbo].[CampaignBig]
	ADD CONSTRAINT [FK_CampaignBig_Campaign] FOREIGN KEY([IDCampaign]) REFERENCES [dbo].[Campaign] ([IDCampaign]);