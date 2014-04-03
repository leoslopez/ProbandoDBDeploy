CREATE PROCEDURE [dbo].[InsertUpdateExtrasTracking] @Table TYPEEXTRASTRACKING READONLY 
AS
BEGIN
	SET NOCOUNT ON
	MERGE SocialNetworkExtrasTracking WITH (HOLDLOCK) AS [Target]
	USING (SELECT * FROM @Table t) AS [Source] 
      ON ([Target].IdSocialNetworkExtras = [Source].IdSocialNetworkExtras 
           AND [Target].IdSubscriber = [Source].IdSubscriber
		   AND [Target].IdCampaign = [Source].IdCampaign)
	WHEN MATCHED THEN
		UPDATE
		SET [Target].Count = [Target].Count + [Source].CountOpens,
		    [Target].Date  =  [Source].OpenDate 
	
	WHEN NOT MATCHED THEN
		INSERT (IdSubscriber, IdSocialNetworkExtras, IdCampaign, Count, Date)
		VALUES ([Source].IdSubscriber, [Source].IdSocialNetworkExtras,  [Source].IdCampaign, [Source].CountOpens,[Source].OpenDate);
END