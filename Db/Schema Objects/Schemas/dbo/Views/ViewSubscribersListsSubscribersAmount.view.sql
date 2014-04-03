CREATE VIEW [dbo].[ViewSubscribersListsSubscribersAmount]  WITH SCHEMABINDING
AS
SELECT 
	[sxl].IdSubscribersList,
	COUNT_BIG(*) AS Amount
	FROM  [dbo].[SubscriberXList] AS [sxl]
	INNER JOIN [dbo].[Subscriber] AS [s] ON [sxl].[IdSubscriber] = [s].[IdSubscriber]
	WHERE (1 = [sxl].[Active]) AND (1 = [s].[IdSubscribersStatus] OR 2 = [s].[IdSubscribersStatus])
	GROUP BY [sxl].IdSubscribersList