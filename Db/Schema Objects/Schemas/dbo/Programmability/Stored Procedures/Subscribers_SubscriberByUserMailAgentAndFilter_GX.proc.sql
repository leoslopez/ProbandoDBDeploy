/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberByUserMailAgentAndFilter_GX]    Script Date: 08/07/2013 11:42:49 ******/


CREATE PROCEDURE [dbo].[Subscribers_SubscriberByUserMailAgentAndFilter_GX] @IdCampaign          int, 
                                                                          @CampaignStatus      int,
                                                                          @IdUserMailAgentType int,
                                                                          @EmailNameFilter     varchar(50),
                                                                          @firstNameFilter     varchar(50),
                                                                          @lastNameFilter      varchar(50),
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
           AND s.Email like @EmailNameFilter 
           AND ISNULL(s.Firstname, '') like @FirstNameFilter 
           AND ISNULL(s.lastname, '') like @LastNameFilter 