﻿/*CREATE NONCLUSTERED INDEX [IX_Campaign_User]
    ON [dbo].[Campaign]([IdUser] ASC, [Active] ASC, [Status] ASC, [TestABCategory] ASC)
    INCLUDE([UTCSentDate], [Name], [Subject]) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [Campaign];*/





GO 