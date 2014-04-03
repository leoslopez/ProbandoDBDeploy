
CREATE PROCEDURE [dbo].[Subscribers_SubscriberListByCampaign_GX] @IdCampaign int 
AS 
    SELECT SL.IdSubscribersList, 
           SL.Name 
    FROM   dbo.SubscribersListXCampaign SLxC WITH(NOLOCK) 
           JOIN SubscribersList SL WITH(NOLOCK) 
             ON SL.IdSubscribersList = SLxC.IdSubscribersList 
    WHERE  SLxC.IdCampaign = @IdCampaign 
           AND SL.Active = 1 
           AND SL.Visible = 1 
    UNION ALL 
    SELECT SL.IdSubscribersList, 
           SL.Name 
    FROM   Campaign C  WITH(NOLOCK) 
           INNER JOIN TestABSubscriberList TSL  WITH(NOLOCK) 
                   ON TSL.IdTestAB = C.IdTestAB 
           INNER JOIN SubscribersList SL  WITH(NOLOCK) 
                   ON TSL.IdSubscriberList = SL.IdSubscribersList 
    WHERE  C.IdCampaign = @IdCampaign 
           AND SL.Active = 1 
           AND SL.Visible = 1 