/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberBySocialNetworkAndFilter_GX]    Script Date: 08/07/2013 11:42:20 ******/


CREATE PROCEDURE [dbo].[Subscribers_SubscriberBySocialNetworkAndFilter_GX] @IdCampaign      int, 
                                                                          @CampaignStatus  int,
                                                                          @IdSocialNetwork int,
                                                                          @EmailNameFilter varchar(50),
                                                                          @firstNameFilter varchar(50),
                                                                          @lastNameFilter  varchar(50),
                                                                          @howmany         int
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
           snst.Count 
    FROM   @t t 
           join SocialNetworkShareTracking snst WITH(NOLOCK) 
             on t.IdCampaign = snst.IdCampaign 
           JOIN Subscriber s WITH(NOLOCK) 
             on s.IdSubscriber = snst.IdSubscriber 
    WHERE  snst.IdSocialNetwork = @IdSocialNetwork 
           AND s.Email like @EmailNameFilter 
           AND ISNULL(s.Firstname, '') like @FirstNameFilter 
           AND ISNULL(s.lastname, '') like @LastNameFilter 