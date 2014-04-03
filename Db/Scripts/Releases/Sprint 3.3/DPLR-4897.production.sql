ALTER PROCEDURE [dbo].[Subscribers_SubscriberByLink_GX]
@IDCampaign INT,        
@IDLink INT,
@HowMany INT
AS    
SET ROWCOUNT @HowMany 

SELECT s.email, 
	   s.FirstName, 
	   s.LastName, 
	   ISNULL(SUM(lt.Count), 0) 
FROM   dbo.LinkTracking LT WITH(NOLOCK) 
	   LEFT OUTER JOIN Link l 
					ON lt.IdLink = l.IdLink 
	   INNER JOIN Subscriber s WITH(NOLOCK) 
			   ON s.IdSubscriber = lt.IdSubscriber 
WHERE  lt.IdLink IN 
(
	SELECT IdLink FROM Link WHERE IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IDCampaign))		
	AND UrlLink = (SELECT UrlLink FROM Link WHERE IdLink = @IDLink)
)
GROUP  BY s.email, 
		  s.FirstName, 
		  s.LastName 
GO

ALTER PROCEDURE [dbo].[Subscribers_SubscriberByLinkAndFilter_GX]
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
		AND UrlLink = (SELECT UrlLink FROM Link WHERE IdLink = @IDLink)
	)
AND s.Email like @emailFilter
AND ISNULL(s.Firstname,'') like @firstnameFilter
AND ISNULL(s.lastname,'') like @lastnameFilter
GO
