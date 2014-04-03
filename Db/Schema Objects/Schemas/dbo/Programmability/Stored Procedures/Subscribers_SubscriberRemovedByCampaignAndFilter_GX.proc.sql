/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberRemovedByCampaignAndFilter_GX]    Script Date: 08/07/2013 11:44:34 ******/


CREATE PROCEDURE [dbo].[Subscribers_SubscriberRemovedByCampaignAndFilter_GX] @campaignID      int, 
                                                                            @emailFilter     varchar(50),
                                                                            @firstnameFilter varchar(50),
                                                                            @lastnameFilter  varchar(50),
                                                                            @howMany         int
AS 
    SET ROWCOUNT @howMany 

    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   GetTestABSet(@campaignID) 

    SELECT s.email, 
           s.Firstname, 
           s.Lastname, 
           ISNULL (s.UTCUnsubDate, GetDate()) 
    FROM   @t t 
           JOIN dbo.Subscriber s WITH(NOLOCK) 
             on t.IdCampaign = s.IdCampaign 
    WHERE  s.email like @emailFilter 
           AND ISNULL(s.Firstname, '') like @firstnameFilter 
           AND ISNULL(s.lastname, '') like @lastnameFilter 
    ORDER  BY s.UTCUnsubDate desc 