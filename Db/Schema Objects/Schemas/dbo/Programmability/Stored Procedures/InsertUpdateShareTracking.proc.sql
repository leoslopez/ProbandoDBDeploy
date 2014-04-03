CREATE PROCEDURE [dbo].[InsertUpdateShareTracking] @Table TYPESHARETRACKING READONLY 
AS
BEGIN
	SET NOCOUNT ON 

	MERGE SocialNetworkShareTracking WITH (HOLDLOCK) AS [Target]
	USING (SELECT * FROM @Table t WHERE EXISTS (SELECT 1 FROM dbo.Subscriber S (NOLOCK)
						JOIN dbo.Campaign C (NOLOCK) ON C.IdUser = S.IdUser
					    WHERE S.IdSubscriber = t.IdSubscriber AND C.IdCampaign = t.IdCampaign AND C.Active = 1)) AS [Source] 
      ON ([Target].IdSocialNetwork = [Source].IdSocialNetwork 
           AND [Target].IdSubscriber = [Source].IdSubscriber
		   AND [Target].IdCampaign = [Source].IdCampaign)
	WHEN MATCHED THEN
		UPDATE
		SET [Target].Count = [Target].Count + [Source].CountOpens,
		    [Target].Date  =  [Source].OpenDate 
	
	WHEN NOT MATCHED THEN
		INSERT (IdSubscriber, IdSocialNetwork, IdCampaign, Count, Date)
		VALUES ([Source].IdSubscriber, [Source].IdSocialNetwork,  [Source].IdCampaign, [Source].CountOpens,[Source].OpenDate);
END