
CREATE PROCEDURE [dbo].[Scan_Available_Subscribers_Client] @Iduser INT 
AS 
/* Hard Bounced 2,8 */ 
/* Soft Bounced 1,3,4,5,6,7 */ 
    /* Not Open 0 */ 
    DECLARE @Date DATETIME 
    DECLARE @Date_down DATETIME 
    DECLARE @Date_up DATETIME 

    SET @Date=CONVERT(DATETIME, CONVERT(VARCHAR(10), GETDATE(), 101), 101) 

    DECLARE @flag INT 
    DECLARE @SB INT 
    DECLARE @HB INT 
    DECLARE @NO INT 
    DECLARE @ContentType INT 
    DECLARE @IdSubscriber BIGINT 
    DECLARE @ConsecutiveHardBounced INT 
    DECLARE @HardBounceLimit INT 
    DECLARE @ConsecutiveSoftBounced INT 
    DECLARE @SoftBounceLimit INT 
    DECLARE @ConsecutiveUnopendedEmails INT 
    DECLARE @NeverOpenLimit INT 
    DECLARE @CampaignID INT 
    DECLARE @IdDeliveryStatus INT 
    DECLARE @sql VARCHAR(MAX) 
    DECLARE @temp_CampDelive TABLE 
      ( 
         IdCampaign INT, 
         [date]     DATETIME 
      ) 

    SET @date_down='20130101' 
    SET @date_up='20131015' 

    PRINT ( @date_down ) 

    PRINT ( @date_up ) 

    SET @SB=0 
    SET @HB=0 
    SET @NO=0 

    UPDATE Subscriber 
    SET    ConsecutiveHardBounced = 0, 
           ConsecutiveSoftBounced = 0, 
           ConsecutiveUnopendedEmails = 0 
    WHERE  IdUser = @IdUser 

    CREATE TABLE #DELETESUBSCRIBERS 
      ( 
         [IdSubscriber] [BIGINT] NOT NULL, 
         CONSTRAINT [PK_DeleteSubscribers] PRIMARY KEY NONCLUSTERED ([IdSubscriber] ASC) 
      ) 

    --Recorro envios y Actualizo contadores 
    INSERT INTO @temp_CampDelive 
    SELECT c.IdCampaign, 
           c.UTCSentDate 
    FROM   Campaign c 
    WHERE  ( c.UTCSentDate BETWEEN @date_down AND @date_up ) 
           AND c.Status = 5 
           AND c.IdUser = @IdUser 

    DECLARE SUBSC CURSOR FOR 
      SELECT s.IdSubscriber, 
             CASE cdoi.IdDeliveryStatus 
               WHEN 0 THEN 0 
               WHEN 1 THEN 1 
               WHEN 2 THEN 2 
               WHEN 3 THEN 1 
               WHEN 4 THEN 1 
               WHEN 5 THEN 1 
               WHEN 6 THEN 1 
               WHEN 7 THEN 1 
               WHEN 8 THEN 2 
             END                          AS IdDeliveryStatus, 
             ISNULL (s.ConsecutiveHardBounced, 0), 
             u.ConsecutiveHardBounced     AS HardBounceLimit, 
             ISNULL (s.ConsecutiveSoftBounced, 0), 
             u.ConsecutiveSoftBounced     AS SoftBounceLimit, 
             ISNULL (s.ConsecutiveUnopendedEmails, 0), 
             u.ConsecutiveUnopendedEmails AS NeverOpenLimit, 
             cam.ContentType 
      FROM   DBO.Subscriber s WITH (NOLOCK) 
             JOIN DBO.[User] u WITH (NOLOCK) 
               ON s.idUser = u.idUser 
             JOIN DBO.CampaignDeliveriesOpenInfo cdoi WITH (NOLOCK) 
               ON cdoi.IdSubscriber = s.IdSubscriber 
             JOIN Campaign cam WITH (NOLOCK) 
               ON cam.IdCampaign = cdoi.IdCampaign 
                  AND cam.idUser = s.idUser 
             JOIN @temp_CampDelive x 
               ON cdoi.IdCampaign = x.IdCampaign 
      WHERE  s.IdSubscriber NOT IN (SELECT IdSubscriber 
                                    FROM   #DELETESUBSCRIBERS) 
             AND s.IdSubscribersStatus < 3 
             AND u.ConsecutiveHardBounced IS NOT NULL 
             AND u.ConsecutiveSoftBounced IS NOT NULL 
             AND u.ConsecutiveUnopendedEmails IS NOT NULL 
             AND cdoi.IdDeliveryStatus BETWEEN 0 AND 8 
      --and s.IdSubscriber in (42066290,42066291,42066292,42066293,42066293,42066294) 
      ORDER  BY cdoi.idcampaign 

    OPEN SUBSC 

    FETCH NEXT FROM SUBSC INTO @IdSubscriber, @IdDeliveryStatus, @ConsecutiveHardBounced, @HardBounceLimit, @ConsecutiveSoftBounced, @SoftBounceLimit, @ConsecutiveUnopendedEmails, @NeverOpenLimit, @ContentType

    WHILE @@FETCH_STATUS = 0 
      BEGIN 
          IF ( @IdDeliveryStatus = 2 ) -- HARD 
            BEGIN 
                UPDATE Subscriber WITH (ROWLOCK) 
                SET    ConsecutiveHardBounced = ConsecutiveHardBounced + 1 
                WHERE  IdSubscriber = @IdSubscriber 
            END 
          ELSE IF ( @IdDeliveryStatus = 1 ) -- SOFT 
            BEGIN 
                UPDATE Subscriber WITH (ROWLOCK) 
                SET    ConsecutiveSoftBounced = ConsecutiveSoftBounced + 1, 
                       ConsecutiveHardBounced = 0 
                WHERE  IdSubscriber = @IdSubscriber 
            END 
          ELSE IF ( @IdDeliveryStatus = 0 
               AND @ContentType <> 1 ) 
            BEGIN 
                UPDATE Subscriber WITH (ROWLOCK) 
                SET    ConsecutiveUnopendedEmails = ConsecutiveUnopendedEmails + 1, 
                       ConsecutiveHardBounced = 0, 
                       ConsecutiveSoftBounced = 0 
                WHERE  IdSubscriber = @IdSubscriber 
            END 
          ELSE IF ( @IdDeliveryStatus = 0 
               AND @ContentType = 1 
               AND ( @ConsecutiveHardBounced > 0 
                      OR @ConsecutiveSoftBounced > 0 ) ) 
            BEGIN 
                --print(@IdSubscriber) 
                UPDATE Subscriber WITH (ROWLOCK) 
                SET    ConsecutiveHardBounced = 0, 
                       ConsecutiveSoftBounced = 0 
                WHERE  IdSubscriber = @IdSubscriber 
            END 
          ELSE IF ( @IdDeliveryStatus = 100 
               AND ( @ConsecutiveHardBounced > 0 
                      OR @ConsecutiveSoftBounced > 0 
                      OR @ConsecutiveUnopendedEmails > 0 ) ) 
            BEGIN 
                --print(@IdSubscriber) 
                UPDATE Subscriber WITH (ROWLOCK) 
                SET    ConsecutiveHardBounced = 0, 
                       ConsecutiveSoftBounced = 0, 
                       ConsecutiveUnopendedEmails = 0 
                WHERE  IdSubscriber = @IdSubscriber 
            END 

          FETCH NEXT FROM SUBSC INTO @IdSubscriber, @IdDeliveryStatus, @ConsecutiveHardBounced, @HardBounceLimit, @ConsecutiveSoftBounced, @SoftBounceLimit, @ConsecutiveUnopendedEmails, @NeverOpenLimit, @ContentType
      END 

    CLOSE SUBSC 

    DEALLOCATE SUBSC 

    DROP TABLE #DELETESUBSCRIBERS 

    UPDATE Subscriber WITH(ROWLOCK) 
    SET    IdSubscribersStatus = 3, 
           UTCUnsubDate = @Date 
    FROM   Subscriber s 
           JOIN [User] u 
             ON s.IdUser = u.IdUser 
    WHERE  s.ConsecutiveHardBounced >= u.ConsecutiveHardBounced 
           AND s.IdUser = @IdUser 

    UPDATE Subscriber WITH(ROWLOCK) 
    SET    IdSubscribersStatus = 4, 
           UTCUnsubDate = @Date 
    FROM   Subscriber s 
           JOIN [User] u 
             ON s.IdUser = u.IdUser 
    WHERE  s.ConsecutiveSoftBounced >= u.ConsecutiveSoftBounced 
           AND s.IdUser = @IdUser 

    UPDATE Subscriber 
    SET    IdSubscribersStatus = 6, 
           UTCUnsubDate = @Date 
    FROM   Subscriber s 
           JOIN [User] u 
             ON s.IdUser = u.IdUser 
    WHERE  s.ConsecutiveUnopendedEmails >= u.ConsecutiveUnopendedEmails 
           AND s.IdUser = @IdUser 

    UPDATE SubscriberXList 
    SET    Active = 0 
    FROM   SubscriberXList l 
           JOIN Subscriber s 
             ON s.IdSubscriber = l.IdSubscriber 
    WHERE  s.IdUser = @IdUser 
           AND s.UTCUnsubDate = @Date