﻿ALTER TABLE [dbo].[SubscribersListFilter]
    ADD CONSTRAINT [PK_SubscribersListFilter] PRIMARY KEY CLUSTERED ([IdSubscribersListFilter] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
