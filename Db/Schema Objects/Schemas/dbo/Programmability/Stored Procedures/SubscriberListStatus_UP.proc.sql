CREATE PROCEDURE SubscriberListStatus_UP @IdSubscriberList INT, 
                                         @Status           INT 
AS 
  BEGIN 
      UPDATE dbo.SubscribersList 
      SET    SubscribersListStatus = @Status 
      WHERE  IdSubscribersList = @IdSubscriberList 
  END