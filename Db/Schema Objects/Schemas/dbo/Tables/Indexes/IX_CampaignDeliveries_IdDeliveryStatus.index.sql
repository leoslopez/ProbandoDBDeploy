﻿CREATE NONCLUSTERED INDEX [IX_CampaignDeliveries_IdDeliveryStatus]
    ON [dbo].[CampaignDeliveriesOpenInfo]([IdDeliveryStatus] ASC, [Date] ASC)
    INCLUDE([IdSubscriber]) WITH (FILLFACTOR = 98, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [Campaign];



