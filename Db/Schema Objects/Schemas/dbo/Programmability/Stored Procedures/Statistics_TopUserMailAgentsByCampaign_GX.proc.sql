CREATE PROCEDURE [dbo].[Statistics_TopUserMailAgentsByCampaign_GX]
@IdCampaign int
AS
    DECLARE @t TABLE 
      ( 
         idcampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT idcampaign 
    FROM   Gettestabset(@IdCampaign) 

    SELECT u.IdUserMailAgentType, 
           COUNT(c.IdSubscriber) cant 
    FROM   @t t 
           JOIN dbo.CampaignDeliveriesOpenInfo c WITH(NOLOCK) 
             on c.IdCampaign = t.idcampaign 
           JOIN dbo.UserMailAgents u WITH(NOLOCK) 
             ON u.IdUserMailAgent = c.IdUserMailAgent 
    GROUP  BY u.IdUserMailAgentType 
    order  by COUNT(c.IdSubscriber) desc 