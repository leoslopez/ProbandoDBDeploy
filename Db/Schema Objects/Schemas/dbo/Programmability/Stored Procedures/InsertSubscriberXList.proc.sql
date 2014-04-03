  
  CREATE PROCEDURE InsertSubscriberXList @Table            TYPESUBSCRIBERXLIST READONLY, 
                                      @IdSubscriberList INT 
AS 
    INSERT INTO SubscriberXList 
    SELECT @IdSubscriberList, 
           IdSubscriber, 
           1, 
           NULL 
    FROM   @Table 
    EXCEPT 
    SELECT @IdSubscriberList, 
           IdSubscriber, 
           1, 
           NULL 
    FROM   SubscriberXList 
    WHERE  IdSubscribersList = @IdSubscriberList 