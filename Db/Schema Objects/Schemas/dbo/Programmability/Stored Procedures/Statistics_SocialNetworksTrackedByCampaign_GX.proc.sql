/****** Object:  StoredProcedure [dbo].[Statistics_SocialNetworksTrackedByCampaign_GX]    Script Date: 08/07/2013 11:40:17 ******/

CREATE PROCEDURE [dbo].[Statistics_SocialNetworksTrackedByCampaign_GX]
@IdCampaign int,
@CampaignStatusID int
AS
SELECT c.IdSocialNetwork, COUNT(c.IdSubscriber) UniqueShares, p.Count as PublicVisits
FROM dbo.SocialNetworkShareTracking c WITH(NOLOCK)
JOIN dbo.CampaignDeliveriesSocialOpenInfo p WITH(NOLOCK)
on c.IdCampaign=p.IdCampaign
WHERE c.IdCampaign=@IdCampaign
GROUP BY c.IdSocialNetwork, p.Count 