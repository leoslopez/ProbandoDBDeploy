﻿ALTER TABLE [dbo].[Viewer]
    ADD CONSTRAINT [PK_Viewer] PRIMARY KEY CLUSTERED ([IdViewer] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


