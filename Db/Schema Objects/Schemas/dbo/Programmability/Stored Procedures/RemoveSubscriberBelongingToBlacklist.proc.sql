
CREATE PROCEDURE [dbo].[RemoveSubscriberBelongingToBlacklist] @Email VARCHAR(100) 
AS 
  BEGIN 
      DECLARE @IdSubscriber BIGINT 

      SELECT TOP 1 @IdSubscriber = s.IdSubscriber 
      FROM   DBO.Subscriber s 
      WHERE  s.Email = @Email 
             AND s.IdSubscribersStatus IN ( 1, 2 ) 

      IF( @IdSubscriber IS NOT NULL ) 
        BEGIN 
            INSERT INTO SubscriberBlackList WITH(ROWLOCK) 
            SELECT @IdSubscriber, 
                   0, 
                   NULL 
        END 
  END

