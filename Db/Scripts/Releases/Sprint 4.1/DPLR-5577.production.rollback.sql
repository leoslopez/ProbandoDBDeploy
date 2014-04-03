PRINT 'Drop constraint [FK_Subscriber_UnsubscriptionReason] from [Subscriber] table'
ALTER TABLE [Subscriber] DROP CONSTRAINT [FK_Subscriber_UnsubscriptionReason]
GO

PRINT 'Drop cloumn [IdUnsubscriptionReason] from [Subscriber] table'
ALTER TABLE [Subscriber] DROP COLUMN [IdUnsubscriptionReason]
GO

PRINT 'Drop [UnsubscriptionReason] table'
DROP TABLE [UnsubscriptionReason]
GO

PRINT 'Alter [UnSubscribe_Subscripters] SP'
GO
ALTER PROCEDURE [dbo].[UnSubscribe_Subscripters] @Table TypeUnSubscriber READONLY 
AS
BEGIN
	SET NOCOUNT ON 

	MERGE Subscriber WITH (HOLDLOCK) AS [Target]
	USING (SELECT * FROM @Table t) AS [Source] 
      ON ([Target].IdSubscriber = [Source].IdSubscriber)
	
	WHEN MATCHED THEN
		UPDATE
		SET [Target].IdSubscribersStatus = 5,
		    [Target].UTCUnsubDate = GETUTCDATE(),
		    [Target].IdCampaign = [Source].IdCampaign;
        
	
	  DELETE FROM [dbo].[SubscriberXList]
		FROM  [dbo].[SubscriberXList] sxl
			JOIN @Table t on sxl.IdSubscriber = t.IdSubscriber

END