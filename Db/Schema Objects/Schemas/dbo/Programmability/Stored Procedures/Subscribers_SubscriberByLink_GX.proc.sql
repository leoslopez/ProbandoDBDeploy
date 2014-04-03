
  
------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Subscribers_SubscriberByLink_GX]
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
	AND UrlLink COLLATE SQL_Latin1_General_CP1_CS_AS = (SELECT UrlLink COLLATE SQL_Latin1_General_CP1_CS_AS FROM Link WHERE IdLink = @IDLink)
)
GROUP  BY s.email, 
		  s.FirstName, 
		  s.LastName 

GO 
