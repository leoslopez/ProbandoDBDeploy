CREATE PROCEDURE [dbo].[Subscribers_SubscriberRemovedByCampaign_GX] @campaignID int, 
                                                                   @howMany    int 
AS 
    SET ROWCOUNT @howMany 

    SELECT s.email, 
           s.Firstname, 
           s.Lastname, 
           ISNULL (s.UTCUnsubDate, GetDate()) 
    FROM   dbo.Subscriber s WITH(NOLOCK) 
    WHERE  s.IdCampaign IN (SELECT IdCampaign 
                            FROM   GetTestABSet(@campaignID)) 
    ORDER  BY UTCUnsubDate desc 