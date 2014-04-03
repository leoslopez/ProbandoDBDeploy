CREATE PROCEDURE [dbo].[Statistics_TopSocialNetworksTrackedByCampaign_GX]
@IdCampaign int,    
@CampaignStatusID int    
AS    
    DECLARE @t TABLE 
      ( 
         idcampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT idcampaign 
    FROM   Gettestabset(@IdCampaign) 

    SELECT IdSocialNetwork, 
           SUM(UniqueShares) UniqueShares, 
           SUM(PublicVisits) PublicVisits 
    FROM   (SELECT c.IdSocialNetwork, 
                   SUM(c.Count) UniqueShares, 
                   0            as PublicVisits 
            FROM   @t t 
                   JOIN dbo.SocialNetworkShareTracking c WITH(NOLOCK) 
                     on t.idcampaign = c.IdCampaign 
            GROUP  BY c.IdSocialNetwork 
            UNION 
            SELECT p.IdSocialNetwork, 
                   0                       as UniqueShares, 
                   isnull(SUM(p.Count), 0) as PublicVisits 
            FROM   @t t 
                   JOIN dbo.CampaignDeliveriesSocialOpenInfo p WITH(NOLOCK) 
                     on t.idcampaign = p.IdCampaign 
            GROUP  BY p.IdSocialNetwork)t 
    GROUP  BY IdSocialNetwork 
    ORDER  BY UniqueShares desc 