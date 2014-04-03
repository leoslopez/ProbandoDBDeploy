/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberCountByFilter_GX]    Script Date: 08/07/2013 11:42:55 ******/


CREATE PROCEDURE [dbo].[Subscribers_SubscriberCountByFilter_GX] @IdUser          int, 
                                                               @emailFilter     varchar(50), 
                                                               @firstnameFilter varchar(50), 
                                                               @lastnameFilter  varchar(50) 
AS 
    SELECT COUNT(s.IdSubscriber) 
    FROM   dbo.Subscriber s WITH(NOLOCK) 
    WHERE  s.IdUser = @IdUser 
           AND s.Email like @emailFilter 
           AND ISNULL(s.Firstname, '') like @firstnameFilter 
           AND ISNULL(s.lastname, '') like @lastnameFilter