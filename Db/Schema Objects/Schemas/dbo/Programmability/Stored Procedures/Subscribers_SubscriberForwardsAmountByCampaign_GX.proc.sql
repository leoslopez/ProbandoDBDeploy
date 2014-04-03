/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberForwardsAmountByCampaign_GX]    Script Date: 08/07/2013 11:43:00 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberForwardsAmountByCampaign_GX]
--> Devuelve una lista de suscriptores y la cantidad de forwards que hizo cada suscriptor.   
@Idcampaign int,  
@howMany int  
AS  
SET ROWCOUNT @howMany  
  
SELECT s.email, s.Firstname, s.Lastname, count(f.email) as ForwardsCount  
FROM dbo.Subscriber s WITH(NOLOCK)  
JOIN dbo.ForwardFriend f WITH(NOLOCK)  
ON s.IdSubscriber=f.IdSubscriber   
WHERE f.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@Idcampaign))
GROUP BY s.email, s.Firstname, s.Lastname  
ORDER BY count(f.email) desc 