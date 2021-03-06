﻿CREATE NONCLUSTERED INDEX [IX_IdTestAB]
    ON [dbo].[Campaign]([IdTestAB] ASC, [TestABCategory] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, DATA_COMPRESSION = PAGE, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = ON, ONLINE = OFF, MAXDOP = 0)
    ON [Campaign];



GO 