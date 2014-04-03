CREATE PROCEDURE UpdateInactiveSubscribers @IdSubscriberList INT 
AS 
  BEGIN 
      UPDATE dbo.Subscriber 
      SET    IdSubscribersStatus = 1 
      FROM   dbo.Subscriber s 
             JOIN dbo.SubscriberXList sxl 
               ON sxl.IdSubscriber = s.idsubscriber 
      WHERE  sxl.IdSubscribersList = @IdSubscriberList 
             AND s.IdSubscribersStatus = 2 
  END