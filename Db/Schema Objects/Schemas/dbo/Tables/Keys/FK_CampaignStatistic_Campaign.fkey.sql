ALTER TABLE [dbo].[CampaignStatistic]
    ADD CONSTRAINT [FK_CampaignStatistic_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE CASCADE ON UPDATE NO ACTION;