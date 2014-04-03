/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberListByFilter_GX]    Script Date: 08/07/2013 11:44:04 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberListByFilter_GX]
@IdUser INT,
@emailFilter varchar(50),
@firstnameFilter varchar(50),
@lastnameFilter varchar(50),
@howmany int
AS

SET ROWCOUNT @howmany

SELECT IdSubscriber, s.Email, s.FirstName, s.LastName, 0 AS "UnsubDetail", [IdSubscribersStatus]
FROM dbo.Subscriber s WITH(NOLOCK)
WHERE s.IdUser=@IdUser 
AND s.Email like @emailFilter
AND ISNULL(s.FirstName,'') like @firstnameFilter
AND ISNULL(s.LastName, '') like @lastnameFilter
ORDER BY s.Email