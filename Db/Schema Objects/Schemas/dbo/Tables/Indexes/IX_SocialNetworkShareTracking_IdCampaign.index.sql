﻿CREATE UNIQUE CLUSTERED INDEX [IX_SocialNetworkShareTracking_IdCampaign]
    ON [dbo].[SocialNetworkShareTracking]([IdCampaign] ASC, [IdSocialNetwork] ASC, [IdSubscriber] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);



