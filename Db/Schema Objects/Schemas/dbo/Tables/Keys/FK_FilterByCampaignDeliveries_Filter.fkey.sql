ALTER TABLE [dbo].[FilterByCampaignDeliveries]
    ADD CONSTRAINT [FK_FilterByCampaignDeliveries_Filter] FOREIGN KEY ([IdFilter]) REFERENCES [dbo].[Filter] ([IdFilter]) ON DELETE CASCADE ON UPDATE NO ACTION;


GO
ALTER TABLE [dbo].[FilterByCampaignDeliveries] CHECK CONSTRAINT [FK_FilterByCampaignDeliveries_Filter];



