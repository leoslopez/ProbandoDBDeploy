﻿ALTER TABLE [dbo].[Statistics]
    ADD CONSTRAINT [PK_Statistics] PRIMARY KEY CLUSTERED ([StatsId] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = ON);





