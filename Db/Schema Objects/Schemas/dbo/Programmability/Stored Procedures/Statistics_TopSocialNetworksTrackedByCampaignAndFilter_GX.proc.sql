CREATE PROCEDURE [dbo].[Statistics_TopSocialNetworksTrackedByCampaignAndFilter_GX]
@IdCampaign int,   
@CampaignStatusID int,   
@EmailNameFilter varchar(50),   
@firstNameFilter varchar(50),   
@lastNameFilter varchar(50) AS  
    DECLARE @t TABLE 
      ( 
         idcampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT idcampaign 
    FROM   Gettestabset(@IdCampaign) 

    select t1.IdSocialNetwork, 
           t1.UniqueShares, 
           ISNULL(SUM(t2.PublicVisits), 0) PublicVisits 
    FROM   (SELECT c.IdSocialNetwork, 
                   SUM(c.count) UniqueShares, 
                   0            as PublicVisits 
            FROM   @t t 
                   JOIN dbo.SocialNetworkShareTracking c WITH(NOLOCK) 
                     on t.idcampaign = c.IdCampaign 
                   JOIN Subscriber s WITH(NOLOCK) 
                     on c.IdSubscriber = s.IdSubscriber 
            WHERE  s.Email like @EmailNameFilter 
                   AND ISNULL(s.Firstname, '') like @FirstNameFilter 
                   AND ISNULL(s.lastname, '') like @LastNameFilter 
            GROUP  BY c.IdSocialNetwork)t1 
           LEFT JOIN (SELECT p.IdSocialNetwork, 
                             0                  as UniqueShares, 
                             isnull(p.Count, 0) as PublicVisits 
                      FROM   @t t 
                             JOIN dbo.CampaignDeliveriesSocialOpenInfo p WITH(NOLOCK) 
                               on t.idcampaign = p.IdCampaign)t2 
                  ON t1.IdSocialNetwork = t2.IdSocialNetwork 
    group  by t1.IdSocialNetwork, 
              t1.UniqueShares 
    ORDER  BY UniqueShares desc 