﻿ALTER TABLE [dbo].[AdminQuestion]
    ADD CONSTRAINT [PK_AdminQuestion] PRIMARY KEY CLUSTERED ([IdQuestion] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
