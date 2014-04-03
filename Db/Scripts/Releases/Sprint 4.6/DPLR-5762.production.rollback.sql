PRINT N'Dropping [dbo].[ViewSubscribersListsSubscribersAmount].[IX_VIdSubscribersList]...';


GO
DROP INDEX [IX_VIdSubscribersList]
    ON [dbo].[ViewSubscribersListsSubscribersAmount];


GO
PRINT N'Altering [dbo].[ViewSubscribersListsSubscribersAmount]...';


GO
ALTER VIEW [dbo].[ViewSubscribersListsSubscribersAmount]  WITH SCHEMABINDING
AS
SELECT 
	[sxl].IdSubscribersList,
	COUNT_BIG(*) AS Amount
	FROM  [dbo].[SubscriberXList] AS [sxl]
	INNER JOIN [dbo].[Subscriber] AS [s] ON [sxl].[IdSubscriber] = [s].[IdSubscriber]
	WHERE (1 = [sxl].[Active]) AND (1 = [s].[IdSubscribersStatus])
	GROUP BY [sxl].IdSubscribersList
GO
PRINT N'Creating [dbo].[ViewSubscribersListsSubscribersAmount].[IX_VIdSubscribersList]...';


GO
SET ARITHABORT ON
GO

SET CONCAT_NULL_YIELDS_NULL ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_WARNINGS ON
GO

SET NUMERIC_ROUNDABORT OFF
GO

CREATE UNIQUE CLUSTERED INDEX [IX_VIdSubscribersList]
    ON [dbo].[ViewSubscribersListsSubscribersAmount]([IdSubscribersList] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];


GO
