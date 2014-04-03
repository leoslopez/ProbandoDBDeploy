CREATE PROCEDURE [dbo].[InsertUpdateLinkTracking] @Table TYPELINKTRACKING READONLY 
AS
BEGIN
	SET NOCOUNT ON
	MERGE LinkTracking WITH (HOLDLOCK) AS [Target]
	USING (SELECT * FROM @Table t WHERE EXISTS (SELECT 1 FROM dbo.Subscriber S (NOLOCK)
		   			JOIN dbo.Campaign C (NOLOCK) ON C.IdUser = S.IdUser
					    WHERE S.IdSubscriber = t.IdSubscriber AND C.IdCampaign = t.IdCampaign AND C.Active = 1)) AS [Source] 
      ON ([Target].IdLink = [Source].IdLink 
           AND [Target].IdSubscriber = [Source].IdSubscriber)

	WHEN MATCHED THEN
		UPDATE
		SET [Target].Count = [Target].Count + [Source].CountOpens,
		    [Target].Date  =  [Source].OpenDate 
	
	WHEN NOT MATCHED THEN
		INSERT (IdLink, IdSubscriber, Count, Date)
		VALUES ([Source].IdLink, [Source].IdSubscriber, [Source].CountOpens,[Source].OpenDate);
END