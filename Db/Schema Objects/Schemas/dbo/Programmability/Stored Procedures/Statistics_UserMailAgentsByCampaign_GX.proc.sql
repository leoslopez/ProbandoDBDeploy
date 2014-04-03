/****** Object:  StoredProcedure [dbo].[Statistics_UserMailAgentsByCampaign_GX]    Script Date: 08/07/2013 11:40:53 ******/


CREATE PROCEDURE [dbo].[Statistics_UserMailAgentsByCampaign_GX] @IdCampaign int 
AS 
    SELECT IdUserMailAgent, 
           [IdPlatform], 
           Count(Count) 
    FROM   dbo.CampaignDeliveriesOpenInfo WITH(NOLOCK) 
    WHERE  IdCampaign = @IdCampaign 
    GROUP  BY IdUserMailAgent, 
              [IdPlatform] 