/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberByUserMailAgent_GX]    Script Date: 08/07/2013 11:42:37 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberByUserMailAgent_GX] @IdCampaign          int, 
                                                                 @CampaignStatus      int, 
                                                                 @IdUserMailAgentType int, 
                                                                 @howmany             int 
AS 
    SET ROWCOUNT @howmany 

    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   Gettestabset(@IdCampaign) 

    SELECT s.Email, 
           s.FirstName, 
           s.LastName, 
           c.Count 
    FROM   @t t 
           JOIN CampaignDeliveriesOpenInfo c WITH(NOLOCK) 
             on t.IdCampaign = c.IdCampaign 
           JOIN Subscriber s WITH(NOLOCK) 
             ON s.IdSubscriber = c.IdSubscriber 
           JOIN dbo.UserMailAgents u WITH(NOLOCK) 
             on c.IdUserMailAgent = u.IdUserMailAgent 
    WHERE  u.IdUserMailAgentType = @IdUserMailAgentType 