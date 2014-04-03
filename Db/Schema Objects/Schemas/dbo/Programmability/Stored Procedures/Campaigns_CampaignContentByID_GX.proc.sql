CREATE PROCEDURE [dbo].[Campaigns_CampaignContentByID_GX]
@IDCampaign INT,  
@IdCampaignType INT  
AS     
    SELECT co.Content 
    FROM Campaign c WITH(NOLOCK)
    JOIN Content co WITH(NOLOCK)
    ON c.IdCampaign=co.IdCampaign 
    WHERE  c.IdCampaign = @IdCampaign
GO