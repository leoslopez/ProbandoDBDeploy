﻿CREATE NONCLUSTERED INDEX [IX_BillingCredits_PaymentDate]
    ON [dbo].[BillingCredits]([PaymentDate] ASC, [IdBillingCreditType] ASC)
    INCLUDE([IdUserTypePlan], [ActivationDate]) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];



