
CREATE PROCEDURE [dbo].[Scan_Available_Subscribers] 
AS 
/* Hard Bounced 2,8 */ 
/* Soft Bounced 1,3,4,5,6,7 */ 
    /* Not Open 0 */ 
    DECLARE @Date DATETIME 
    DECLARE @Date_down DATETIME 
    DECLARE @Date_up DATETIME 

    SET @Date=CONVERT(DATETIME, CONVERT(VARCHAR(10), GETUTCDATE(), 101), 101) 

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

    SET @date_down=DATEADD(DD, -2, @Date) 
    SET @date_up=DATEADD(DD, -1, @Date) 
    SET @Date=DATEADD(DD, -1, @Date) 

    PRINT( @date_down ) 

    PRINT( @date_up ) 

    SET @SB=0 
    SET @HB=0 
    SET @NO=0 

    CREATE TABLE #OPENS 
      ( 
         [IdSubscriber] [BIGINT] NOT NULL, 
         CONSTRAINT [PK_Opens] PRIMARY KEY NONCLUSTERED ( [IdSubscriber] ASC ) 
      ) 

    -- Recorro Opens y Actualizo Subscribers            
    INSERT INTO #OPENS 
                (IdSubscriber) 
    SELECT DISTINCT c.IdSubscriber 
    FROM   DBO.CampaignDeliveriesOpenInfo c WITH (NOLOCK) 
    WHERE  c.[date] BETWEEN @date_down AND @date_up 
           AND c.IdDeliveryStatus = 100 

    DELETE FROM dbo.BlacklistEmail 
    FROM   dbo.BlacklistEmail ble 
           JOIN dbo.Subscriber s 
             ON s.Email = ble.email 
           JOIN #OPENS o 
             ON o.IdSubscriber = s.IdSubscriber 
           JOIN dbo.BlackListSource bls 
             ON bls.IdSource = ble.IdSource 
    WHERE  bls.CanBeRevived = 1 

    DECLARE @TotalOpens INT 

    SELECT @TotalOpens = COUNT(Idsubscriber) 
    FROM   #OPENS 

    DECLARE @START INT 
    DECLARE @END INT 
    DECLARE @AMOUNT INT 

    SET @AMOUNT = 10000 
    SET @START = 1 
    SET @END = @START + @AMOUNT 

  BEGIN TRY 
      WHILE ( @START < @TotalOpens ) 
        BEGIN 
            UPDATE Subscriber WITH(ROWLOCK) 
            SET    IdSubscribersStatus = ( CASE 
                                             WHEN s.IdSubscribersStatus IN ( 1, 2 ) THEN s.IdSubscribersStatus
                                             ELSE 2 
                                           END ), 
                   UTCUnsubDate = NULL, 
                   ConsecutiveHardBounced = 0, 
                   ConsecutiveSoftBounced = 0, 
                   ConsecutiveUnopendedEmails = 0 
            FROM   dbo.Subscriber s 
                   JOIN (SELECT IdSubscriber, 
                                ROW_NUMBER() 
                                  OVER ( 
                                    ORDER BY IdSubscriber) rownumber 
                         FROM   #OPENS) o 
                     ON o.IdSubscriber = s.IdSubscriber 
            WHERE  IdSubscribersStatus NOT IN ( 5, 8 ) 
                   AND o.rownumber BETWEEN @START AND @END 

            SET @START = @END + 1 
            SET @END = @END + @AMOUNT 
        END 
  END TRY 

  BEGIN CATCH 
      SELECT ERROR_NUMBER()  AS ErrorNumber, 
             ERROR_MESSAGE() AS ErrorMessage; 
  END CATCH 

    --Recorro envios y Actualizo contadores       
    INSERT INTO @temp_CampDelive 
    SELECT c.IdCampaign, 
           c.UTCSentDate 
    FROM   Campaign c 
    WHERE  ( c.UTCSentDate BETWEEN @date_down AND @date_up ) 
           AND c.Status = 5 

    DECLARE SUBSC CURSOR FOR 
      SELECT DISTINCT s.IdSubscriber, 
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
                      ISNULL(s.ConsecutiveHardBounced, 0), 
                      u.ConsecutiveHardBounced     AS HardBounceLimit, 
                      ISNULL(s.ConsecutiveSoftBounced, 0), 
                      u.ConsecutiveSoftBounced     AS SoftBounceLimit, 
                      ISNULL(s.ConsecutiveUnopendedEmails, 0), 
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
                                    FROM   #OPENS) 
             AND s.IdSubscribersStatus < 3 
             AND u.ConsecutiveHardBounced IS NOT NULL 
             AND u.ConsecutiveSoftBounced IS NOT NULL 
             AND u.ConsecutiveUnopendedEmails IS NOT NULL 
             AND cdoi.IdDeliveryStatus BETWEEN 0 AND 8 
      ORDER  BY CASE cdoi.IdDeliveryStatus 
                  WHEN 0 THEN 0 
                  WHEN 1 THEN 1 
                  WHEN 2 THEN 2 
                  WHEN 3 THEN 1 
                  WHEN 4 THEN 1 
                  WHEN 5 THEN 1 
                  WHEN 6 THEN 1 
                  WHEN 7 THEN 1 
                  WHEN 8 THEN 2 
                END DESC 

    OPEN SUBSC 

    FETCH NEXT FROM SUBSC INTO @IdSubscriber, @IdDeliveryStatus, @ConsecutiveHardBounced, @HardBounceLimit, @ConsecutiveSoftBounced, @SoftBounceLimit, @ConsecutiveUnopendedEmails, @NeverOpenLimit, @ContentType

    WHILE @@FETCH_STATUS = 0 
      BEGIN 
          IF ( @IdDeliveryStatus = 2 ) -- HARD       
            BEGIN 
                IF ( @ConsecutiveHardBounced + 1 >= @HardBounceLimit ) 
                  BEGIN 
                      BEGIN TRY 
                          UPDATE Subscriber WITH (ROWLOCK) 
                          SET    ConsecutiveHardBounced = @ConsecutiveHardBounced + 1, 
                                 UTCUnsubDate = @date, 
                                 IdSubscribersStatus = 3 
                          WHERE  IdSubscriber = @IdSubscriber 

                          UPDATE SubscriberXList 
                          SET    Active = 0, 
                                 UTCDeleteDate = @date 
                          WHERE  IdSubscriber = @IdSubscriber 
                      END TRY 

                      BEGIN CATCH 
                          SELECT ERROR_NUMBER()  AS ErrorNumber, 
                                 ERROR_MESSAGE() AS ErrorMessage; 
                      END CATCH 
                  END 
                ELSE 
                  UPDATE Subscriber WITH (ROWLOCK) 
                  SET    ConsecutiveHardBounced = @ConsecutiveHardBounced + 1 
                  WHERE  IdSubscriber = @IdSubscriber 
            END 
          ELSE IF ( @IdDeliveryStatus = 1 ) -- SOFT       
            BEGIN 
                IF ( @ConsecutiveSoftBounced + 1 >= @SoftBounceLimit ) 
                  BEGIN 
                      BEGIN TRY 
                          UPDATE Subscriber WITH (ROWLOCK) 
                          SET    ConsecutiveSoftBounced = @ConsecutiveSoftBounced + 1, 
                                 UTCUnsubDate = @date, 
                                 IdSubscribersStatus = 4 
                          WHERE  IdSubscriber = @IdSubscriber 
                      END TRY 

                      BEGIN CATCH 
                          SELECT ERROR_NUMBER()  AS ErrorNumber, 
                                 ERROR_MESSAGE() AS ErrorMessage; 
                      END CATCH 
                  END 
                ELSE 
                  UPDATE Subscriber WITH (ROWLOCK) 
                  SET    ConsecutiveSoftBounced = @ConsecutiveSoftBounced + 1, 
                         ConsecutiveHardBounced = 0 
                  WHERE  IdSubscriber = @IdSubscriber 
            END 
          ELSE IF ( @IdDeliveryStatus = 0 
               AND @ContentType <> 1 ) 
            BEGIN 
                IF ( @ConsecutiveUnopendedEmails + 1 >= @NeverOpenLimit ) 
                   AND ( @NeverOpenLimit <> 0 ) 
                  BEGIN 
                      BEGIN TRY 
                          UPDATE Subscriber WITH (ROWLOCK) 
                          SET    ConsecutiveUnopendedEmails = @ConsecutiveUnopendedEmails + 1,
                                 UTCUnsubDate = @date, 
                                 IdSubscribersStatus = 6 
                          WHERE  IdSubscriber = @IdSubscriber 

                          UPDATE SubscriberXList 
                          SET    Active = 0, 
                                 UTCDeleteDate = @date 
                          WHERE  IdSubscriber = @IdSubscriber 
                      END TRY 

                      BEGIN CATCH 
                          ROLLBACK TRAN 

                          SELECT ERROR_NUMBER()  AS ErrorNumber, 
                                 ERROR_MESSAGE() AS ErrorMessage; 
                      END CATCH 
                  END 
                ELSE 
                  UPDATE Subscriber WITH (ROWLOCK) 
                  SET    ConsecutiveUnopendedEmails = @ConsecutiveUnopendedEmails + 1, 
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

          FETCH NEXT FROM SUBSC INTO @IdSubscriber, @IdDeliveryStatus, @ConsecutiveHardBounced, @HardBounceLimit, @ConsecutiveSoftBounced, @SoftBounceLimit, @ConsecutiveUnopendedEmails, @NeverOpenLimit, @ContentType
      END 

    CLOSE SUBSC 

    DEALLOCATE SUBSC 

    DROP TABLE #OPENS