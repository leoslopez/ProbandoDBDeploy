﻿ALTER TABLE [dbo].[Industry]
    ADD CONSTRAINT [PK_Industries] PRIMARY KEY CLUSTERED ([IdIndustry] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);



