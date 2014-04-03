/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberByCampaignMailDeliveryStatusAndFilter_GX]    Script Date: 08/07/2013 11:41:29 ******/


CREATE PROCEDURE [dbo].[Subscribers_SubscriberByCampaignMailDeliveryStatusAndFilter_GX] @IdCampaign         INT, 
                                                                                       @CampaignStatus     INT,
                                                                                       @MailDeliveryStatus INT,-- NotOpened = 0,Bounced = 1,Opened = 2,NotSent = 3  
                                                                                       @emailFilter        varchar(50),
                                                                                       @firstnameFilter    varchar(50),
                                                                                       @lastnameFilter     varchar(50),
                                                                                       @HowMany            INT
AS 
    SET ROWCOUNT @HowMany 

    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   Gettestabset(@IdCampaign) 

    IF ( @MailDeliveryStatus = 2 ) 
      BEGIN 
          SELECT S.Email, 
                 S.FirstName, 
                 S.LastName, 
                 C.[Date], 
                 ISNULL(C.Count, 1) OpenCount 
          FROM   @t t 
                 JOIN dbo.CampaignDeliveriesOpenInfo C WITH(NOLOCK) 
                   ON t.IdCampaign = c.IdCampaign 
                 JOIN Subscriber S WITH(NOLOCK, INDEX(PK_Suscriber)) 
                   ON S.IdSubscriber = C.IdSubscriber 
          WHERE  C.IdDeliveryStatus = 100 
                 AND s.email LIKE @emailFilter 
                 AND ISNULL(s.Firstname, '') like @firstnameFilter 
                 AND ISNULL(s.lastname, '') like @lastnameFilter 
      END 
    ELSE IF ( @MailDeliveryStatus = 0 ) 
      BEGIN 
          SELECT S.Email, 
                 S.FirstName, 
                 S.LastName 
          FROM   @t t 
                 JOIN dbo.CampaignDeliveriesOpenInfo C WITH(NOLOCK) 
                   ON t.IdCampaign = c.IdCampaign 
                 JOIN Subscriber S WITH(NOLOCK, INDEX(PK_Suscriber)) 
                   ON S.IdSubscriber = C.IdSubscriber 
          WHERE  C.IdDeliveryStatus = 0 
                 AND s.email LIKE @emailFilter 
                 AND ISNULL(s.Firstname, '') like @firstnameFilter 
                 AND ISNULL(s.lastname, '') like @lastnameFilter 
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
                   ON t.IdCampaign = c.IdCampaign 
                 JOIN Subscriber S WITH(NOLOCK, INDEX(PK_Suscriber)) 
                   ON S.IdSubscriber = C.IdSubscriber 
          WHERE  C.IdDeliveryStatus between 1 AND 8 
                 AND s.email LIKE @emailFilter 
                 AND ISNULL(s.Firstname, '') like @firstnameFilter 
                 AND ISNULL(s.lastname, '') like @lastnameFilter 
      END 