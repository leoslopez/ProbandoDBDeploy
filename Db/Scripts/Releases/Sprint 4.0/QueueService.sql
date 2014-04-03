-- =============================================
-- Script Template
-- =============================================
CREATE TYPE [dbo].[TypeExtrasTracking] AS TABLE 
(
			CountOpens INT,
			IdCampaign INT,
			IdSocialNetworkExtras INT,
	        IdSubscriber INT,
			OpenDate DateTime			
)

GO

CREATE TYPE TypeLinkTracking AS TABLE (
			CountOpens INT,
			IdCampaign INT,
		    IdLink INT,
		 	IdSubscriber INT,
		    OpenDate DateTime		
		)

GO

CREATE TYPE TypeRegisterOpen AS TABLE (
			AutoIncrement BIT,
			CountOpens INT,
			IdCampaign INT,
			IdPlatform INT,
			IdSubscriber INT,
			IdUserMailAgent INT,
			IpAddress VARCHAR(100),
			IpNumber BIGINT,
			OpenDate DateTime
		)
GO

CREATE TYPE TypeRegisterSocialOpen AS TABLE (
			CountOpens INT,
			IdCampaign INT,
			IdPlatform INT,
			IdSocialNetwork INT,
			IdSubscriber INT,
			IdUserMailAgent INT,
			IpAddress VARCHAR(100),
			IpNumber BIGINT,
			OpenDate DateTime
	)

GO

CREATE TYPE [dbo].[TypeShareTracking] AS TABLE 
(
			CountOpens INT,
			IdCampaign INT,
			IdSocialNetwork INT,
	        IdSubscriber INT,
			OpenDate DateTime			
)

GO

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

GO

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

GO

CREATE PROCEDURE [dbo].[InsertUpdateOpens] @Table TYPEREGISTEROPEN READONLY 
AS 
  BEGIN     
      SET NOCOUNT ON  
	  MERGE [dbo].CampaignDeliveriesOpenInfo  WITH (HOLDLOCK) AS [Target]
      USING (SELECT *, (SELECT TOP 1 LocId FROM Blocks WITH(NOLOCK) 
			           WHERE t.IpNumber BETWEEN StartIpNum AND EndIpNum) as LocId    
             FROM   @Table t) AS [Source] 
      ON ( [Target].IdCampaign = [Source].IdCampaign 
           AND [Target].IdSubscriber = [Source].IdSubscriber )
   
      WHEN MATCHED THEN 
      UPDATE        
      SET 
         [Target].IpAddress = [Source].IpAddress,
         [Target].IdPlatform = [Source].IdPlatform,
         [Target].IdUserMailAgent =[Source].IdUserMailAgent,
		 [Target].Date = [Source].OpenDate, 
	     [Target].IdDeliveryStatus = 100,
         [Target].LocId = [Source].LocId,
         [Target].Count =   
	     CASE   
		    WHEN ([Source].AutoIncrement = 1) THEN [Target].Count + [Source].CountOpens  
		    WHEN ([Source].AutoIncrement = 0) AND ([Target].Count = 0) THEN 1 
	        ELSE [Target].Count  
	     END	  	 
     
      WHEN NOT MATCHED THEN 
        INSERT (IdCampaign, IdSubscriber, IpAddress, LocId, IdPlatform, IdUserMailAgent, Count, Date, IdDeliveryStatus)  
        VALUES ([Source].IdCampaign, [Source].IdSubscriber, [Source].IpAddress, [Source].LocId, [Source].IdPlatform, [Source].IdUserMailAgent, [Source].CountOpens, [Source].OpenDate, 100);  
 
  END

GO

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

GO

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