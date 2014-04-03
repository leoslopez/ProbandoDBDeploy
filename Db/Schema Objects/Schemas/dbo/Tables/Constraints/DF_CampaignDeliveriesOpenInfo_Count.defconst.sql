ALTER TABLE [dbo].[CampaignDeliveriesOpenInfo]
    ADD CONSTRAINT [DF_CampaignDeliveriesOpenInfo_Count] DEFAULT ((1)) FOR [Count];

