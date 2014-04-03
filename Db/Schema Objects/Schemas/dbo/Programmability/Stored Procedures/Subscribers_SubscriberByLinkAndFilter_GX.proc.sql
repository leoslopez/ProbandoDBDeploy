CREATE PROCEDURE [dbo].[Subscribers_SubscriberByLinkAndFilter_GX]
@IDCampaign INT, 
@IDLink INT,
@emailFilter varchar(50),
@firstnameFilter varchar(50),
@lastnameFilter varchar(50),
@HowMany INT
AS    
SET ROWCOUNT @HowMany    
SELECT s.Email, s.FirstName, s.LastName, lt.Count
FROM dbo.LinkTracking lt WITH(NOLOCK)   
	INNER JOIN Subscriber s WITH(NOLOCK)   
		ON s.IdSubscriber = lt.IdSubscriber
	LEFT OUTER JOIN Link l
		ON lt.IdLink = l.IdLink
WHERE l.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IDCampaign))
AND lt.IdLink IN 
	(
		SELECT IdLink FROM Link WHERE IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IDCampaign))		
		AND UrlLink  COLLATE SQL_Latin1_General_CP1_CS_AS = (SELECT UrlLink  COLLATE SQL_Latin1_General_CP1_CS_AS FROM Link WHERE IdLink = @IDLink)
	)
AND s.Email like @emailFilter
AND ISNULL(s.Firstname,'') like @firstnameFilter
AND ISNULL(s.lastname,'') like @lastnameFilter 

GO 
