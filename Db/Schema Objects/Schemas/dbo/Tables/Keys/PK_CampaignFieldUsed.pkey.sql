﻿ALTER TABLE [dbo].[CampaignFieldUsed]
    ADD CONSTRAINT [PK_CampaignFieldUsed] PRIMARY KEY CLUSTERED ([IdCampaign] ASC, [IdSubscriber] ASC, [IdField] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

 