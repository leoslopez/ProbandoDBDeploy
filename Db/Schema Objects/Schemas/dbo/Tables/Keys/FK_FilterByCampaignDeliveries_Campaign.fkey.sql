ALTER TABLE [dbo].[FilterByCampaignDeliveries]
    ADD CONSTRAINT [FK_FilterByCampaignDeliveries_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE NO ACTION ON UPDATE NO ACTION;




GO
/*ALTER TABLE [dbo].[FilterByCampaignDeliveries] NOCHECK CONSTRAINT [FK_FilterByCampaignDeliveries_Campaign];*/



