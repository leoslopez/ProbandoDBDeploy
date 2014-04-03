CREATE PROCEDURE [dbo].[Subscribers_SubscriberByCampaignAndMailDeliveryStatus_GX]
@IdCampaign INT,         
@CampaignStatus INT,    
@MailDeliveryStatus INT,-- NotOpened = 0,Bounced = 1,Opened = 2,NotSent = 3  
@HowMany INT  
AS  
    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   Gettestabset(@IdCampaign) 

    SET ROWCOUNT @HowMany 

    IF ( @MailDeliveryStatus = 2 ) 
      BEGIN 
          SELECT S.Email, 
                 S.FirstName, 
                 S.LastName, 
                 C.[Date], 
                 ISNULL(C.Count, 1) OpenCount 
          FROM   @t t 
                 JOIN dbo.CampaignDeliveriesOpenInfo C WITH(NOLOCK) 
                   on c.IdCampaign = t.IdCampaign 
                 JOIN Subscriber S WITH(NOLOCK) 
                   ON S.IdSubscriber = C.IdSubscriber 
          WHERE  C.IdDeliveryStatus = 100 
      END 
    ELSE IF ( @MailDeliveryStatus = 0 ) 
      BEGIN 
          SELECT S.Email, 
                 S.FirstName, 
                 S.LastName 
          FROM   @t t 
                 JOIN dbo.CampaignDeliveriesOpenInfo C WITH(NOLOCK) 
                   on t.IdCampaign = c.IdCampaign 
                 JOIN Subscriber S WITH(NOLOCK) 
                   ON S.IdSubscriber = C.IdSubscriber 
          WHERE  C.IdDeliveryStatus = 0 
      END 
    ELSE IF ( @MailDeliveryStatus = 1 ) 
      BEGIN 
          SELECT S.Email, 
                 S.FirstName, 
                 S.LastName, 
                 CASE C.IdDeliveryStatus 
                   WHEN 2 THEN 1001 
                   WHEN 8 THEN 1001 
                   ELSE 1000 
                 END DeliveryStatusID 
          FROM   @t t 
                 JOIN dbo.CampaignDeliveriesOpenInfo C WITH(NOLOCK) 
                   on t.IdCampaign = c.IdCampaign 
                 JOIN Subscriber S WITH(NOLOCK) 
                   ON S.IdSubscriber = C.IdSubscriber 
          WHERE  C.IdDeliveryStatus between 1 AND 8 
      END 