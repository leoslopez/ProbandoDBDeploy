﻿ALTER TABLE [dbo].[Admin]
    ADD CONSTRAINT [PK_Admin] PRIMARY KEY CLUSTERED ([IdAdmin] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);



