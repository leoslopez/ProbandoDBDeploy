ALTER TABLE [dbo].[FilterByCampaignDeliveries]
DROP [FK_FilterByCampaignDeliveries_Filter]
GO

ALTER TABLE [dbo].[FilterByCampaignDeliveries] WITH NOCHECK
ADD CONSTRAINT [FK_FilterByCampaignDeliveries_Filter] FOREIGN KEY ([IdFilter]) 
REFERENCES [dbo].[Filter] ([IdFilter]) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE [dbo].[FilterByCampaignDeliveries] CHECK CONSTRAINT [FK_FilterByCampaignDeliveries_Filter];