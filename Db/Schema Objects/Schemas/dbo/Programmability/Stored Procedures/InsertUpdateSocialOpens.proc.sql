CREATE PROCEDURE [dbo].[InsertUpdateSocialOpens] @Table TYPEREGISTERSOCIALOPEN READONLY 
AS 
  BEGIN   
      SET NOCOUNT ON    
	  MERGE [dbo].CampaignDeliveriesSocialOpenInfo  WITH (HOLDLOCK) AS [Target]
      USING (SELECT *,
	   (SELECT TOP 1 LocId FROM Blocks WITH(NOLOCK) 
		       WHERE t.IpNumber BETWEEN StartIpNum AND EndIpNum) as LocId    
             FROM   @Table t) AS [Source] 
      ON ([Target].IdCampaign = [Source].IdCampaign 
		 AND [Target].IdSocialNetwork = [Source].IdSocialNetwork
		 AND [Target].IdSubscriber = [Source].IdSubscriber)
   
      WHEN MATCHED THEN 
      UPDATE        
      SET [Target].Count = [Target].Count + [Source].CountOpens
	  WHEN NOT MATCHED THEN 
   INSERT (IdCampaign, IdSocialNetwork, IdSubscriber, IpAddress, LocId, IdPlatform, IdUserMailAgent, Count, Date)
	VALUES ([Source].IdCampaign, [Source].IdSocialNetwork, [Source].IdSubscriber, [Source].IpAddress, [Source].LocId, [Source].IdPlatform, [Source].IdUserMailAgent, [Source].CountOpens, [Source].OpenDate);

END