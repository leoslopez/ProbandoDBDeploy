CREATE NONCLUSTERED INDEX [IX_Segment_IsProcessing]
    ON [dbo].[Segment]([IsProcessing] ASC)
    INCLUDE([IdSegment], [IdSegmentType], [IdCriterioPorRanking], [IdCriterioPorRedSocial], [IdFilter], [CountSubscriberSegment], [IsCampaingSending]) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [SubscriberList];

