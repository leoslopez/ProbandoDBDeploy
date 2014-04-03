CREATE PROCEDURE [dbo].[UnSubscribe_Subscripters] @Table TypeUnSubscriber READONLY 
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
		    [Target].IdCampaign = [Source].IdCampaign,
			[Target].IdUnsubscriptionReason = 2;
        
	
	  DELETE FROM [dbo].[SubscriberXList]
		FROM  [dbo].[SubscriberXList] sxl
			JOIN @Table t on sxl.IdSubscriber = t.IdSubscriber

END