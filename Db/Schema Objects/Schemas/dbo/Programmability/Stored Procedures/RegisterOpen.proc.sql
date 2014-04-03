/*******************************************************************************************  
Procedure:  RegisterOpen  
    (Copyright © 2012 Making Sense. All rights reserved.)  
Purpose:  Register that an email campaign has been opened.  
Written by:  Alejandro Fantini  
Tested on:  SQL Server 2008 R2  
Date created: April 13th 2012  
*******************************************************************************************/  
CREATE PROCEDURE [dbo].[RegisterOpen]  
 @IdCampaign int,  -- Campaign that was opened  
 @IdSubscriber int,  -- Subscriber that opened the campaign  
 @ipAddress varchar(50), -- IP address of the subscriber  
 @IpNumber bigint,  -- IP number from the IP address of the subscriber  
 @IdPlatform int,  -- Platform of the subscriber  
 @IdUserMailAgent int, -- User agent of the subscriber  
 @OpenDate datetime,  -- Date and time when the campaing was opened by subscriber  
 @AutoIncrement bit  -- Indicates whether the count must be increased if the opening is already registered  
AS  
declare @locId int  
SET @locId = (SELECT TOP 1 LocId FROM Blocks WITH(NOLOCK) 
			WHERE @IpNumber BETWEEN StartIpNum AND EndIpNum)  
BEGIN  
SET NOCOUNT ON  
-- If a record exists, increment a counter by one; otherwise, insert the record with a value of one. The following MERGE statement wraps this logic and uses the HOLDLOCK hint to avoid race conditions.  
MERGE CampaignDeliveriesOpenInfo AS [Target] 
USING (SELECT 1 AS One) AS [Source]  
ON ([Target].IdCampaign = @IdCampaign AND [Target].IdSubscriber = @IdSubscriber)  
WHEN MATCHED THEN  
 UPDATE  
 SET [Target].Count =   
 CASE   
  WHEN (@AutoIncrement = 1) THEN [Target].Count + 1  
  WHEN (@AutoIncrement = 0) AND ([Target].Count = 0) THEN 1  
  ELSE [Target].Count  
 END,  
 [Target].IpAddress =   
 CASE   
  WHEN ([Target].Count = 0) THEN @ipAddress  
  ELSE [Target].IpAddress  
 END,  
 [Target].LocId =   
 CASE   
  WHEN ([Target].Count = 0) THEN @locId  
  ELSE [Target].LocId  
 END,  
 [Target].IdPlatform =   
 CASE   
  WHEN ([Target].Count = 0) THEN @IdPlatform  
  ELSE [Target].IdPlatform  
 END,  
 [Target].IdUserMailAgent =   
 CASE   
  WHEN ([Target].Count = 0) THEN @IdUserMailAgent  
  ELSE [Target].IdUserMailAgent  
 END,  
 [Target].Date =   
 CASE   
  WHEN ([Target].Count = 0) THEN @OpenDate  
  ELSE [Target].Date  
 END,  
 [Target].IdDeliveryStatus = 100  
WHEN NOT MATCHED THEN  
 INSERT (IdCampaign, IdSubscriber, IpAddress, LocId, IdPlatform, IdUserMailAgent, Count, Date, IdDeliveryStatus)  
 VALUES (@IdCampaign, @IdSubscriber, @ipAddress, @locId, @IdPlatform, @IdUserMailAgent, 1, @OpenDate, 100);  
END
