CREATE PROCEDURE CopyListToList @IdSource  INT, 
                                @IdTarget INT 
AS 
  BEGIN 
      DECLARE @Range INT 
      DECLARE @i INT 
      DECLARE @Amount INT 

      SET @Range = 100000 
      SET @i = 0 

      SELECT @Amount = COUNT(IdSubscriber) 
      FROM   dbo.SubscriberXList sxl WITH(NOLOCK) 
      WHERE  sxl.IdSubscribersList = @IdSource 
             AND sxl.Active = 1 

      WHILE ( ( @i * @Range ) < @Amount ) 
        BEGIN 
            INSERT INTO dbo.SubscriberXList 
                        (Active, 
                         IdSubscriber, 
                         IdSubscribersList, 
                         UTCDeleteDate) 
            SELECT 1, 
                   x.IdSubscriber, 
                   @IdTarget, 
                   NULL 
            FROM   (SELECT sxl.IdSubscriber, 
                           ROW_NUMBER() 
                             OVER( 
                               ORDER BY sxl.IdSubscriber) AS rownumber 
                    FROM   dbo.SubscriberXList sxl 
                           JOIN dbo.Subscriber s 
                             ON s.IdSubscriber = sxl.IdSubscriber 
                    WHERE  IdSubscribersList = @IdSource 
                           AND s.IdSubscribersStatus IN ( 1, 2 )) x 
            WHERE  x.rownumber BETWEEN ( @i * @Range ) + 1 AND ( @i * @Range ) + @Range 

            SET @i = @i + 1 
        END 
  END