-- =============================================
-- Script Template
-- =============================================

DROP PROCEDURE InsertUpdateOpens;

GO

DROP TYPE TypeRegisterOpen;

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
			OpenDate DateTime,
			LocId INT
		)

GO

CREATE PROCEDURE [dbo].[InsertUpdateOpens] @Table TYPEREGISTEROPEN READONLY 
AS 
  BEGIN     
      SET NOCOUNT ON  
	  MERGE [dbo].CampaignDeliveriesOpenInfo  WITH (HOLDLOCK) AS [Target]
      USING (SELECT * FROM @Table t) AS [Source] 
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
         [Target].LocId =
		 CASE   
		    WHEN ([Source].LocId = 0) THEN NULL
			ELSE [Source].LocId 
		 END,
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