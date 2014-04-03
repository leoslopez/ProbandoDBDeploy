CREATE NONCLUSTERED INDEX [IX_CampaignDeliveries_IdCampaignApertures]
    ON [dbo].[CampaignDeliveriesOpenInfo]([IdCampaign] ASC)
    INCLUDE([IdSubscriber], [Count], [LocId], [Date]) WHERE ([IdDeliveryStatus]=(100)) WITH (FILLFACTOR = 98, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [Campaign];



