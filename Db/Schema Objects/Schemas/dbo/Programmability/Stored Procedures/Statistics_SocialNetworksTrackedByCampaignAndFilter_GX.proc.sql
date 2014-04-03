/****** Object:  StoredProcedure [dbo].[Statistics_SocialNetworksTrackedByCampaignAndFilter_GX]    Script Date: 08/07/2013 11:40:23 ******/

CREATE PROCEDURE [dbo].[Statistics_SocialNetworksTrackedByCampaignAndFilter_GX] @IdCampaign       int, 
                                                                               @CampaignStatusID int,
                                                                               @EmailNameFilter  varchar(50),
                                                                               @firstNameFilter  varchar(50),
                                                                               @LastNameFilter   varchar(50)
AS 
    SELECT c.IdSocialNetwork, 
           COUNT(c.IdSubscriber) UniqueShares, 
           p.Count               as PublicVisits 
    FROM   dbo.SocialNetworkShareTracking c WITH(NOLOCK) 
           JOIN dbo.CampaignDeliveriesSocialOpenInfo p WITH(NOLOCK) 
             on c.IdCampaign = p.IdCampaign 
           JOIN Subscriber s WITH(NOLOCK) 
             on c.IdSubscriber = s.IdSubscriber 
    WHERE  c.IdCampaign = @IdCampaign 
           AND s.Email like @EmailNameFilter 
           AND ISNULL(s.Firstname, '') like @FirstNameFilter 
           AND ISNULL(s.lastname, '') like @LastNameFilter 
    GROUP  BY c.IdSocialNetwork, 
              p.Count 