﻿ALTER TABLE [dbo].[MaxSubscribersToValidateHistory]
    ADD CONSTRAINT [PK_MaxSubscribersToValidateHistory] PRIMARY KEY CLUSTERED ([IdMaxSubscribersToValidateHistory] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);



