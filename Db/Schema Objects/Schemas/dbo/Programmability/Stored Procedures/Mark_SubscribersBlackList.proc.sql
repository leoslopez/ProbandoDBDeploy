
CREATE PROCEDURE [dbo].[Mark_SubscribersBlackList] 
AS 
    DECLARE @Date DATE 

    SET @Date=CAST(GETUTCDATE() AS DATE) 

  BEGIN TRY 
      DECLARE @t TABLE 
        ( 
           IDSubscriber BIGINT 
           UNIQUE CLUSTERED (IDSubscriber) 
        ) 

      INSERT @t 
             (IDSubscriber) 
      SELECT DISTINCT S.IdSubscriber 
      FROM   dbo.BlackListEmail BLE 
             JOIN DBO.Subscriber S 
               ON S.Email = BLE.Email 
      WHERE  BLE.Marked = 0  AND S.IdSubscribersStatus IN (1,2)

      INSERT @t 
             (IDSubscriber) 
      SELECT DISTINCT S.IdSubscriber 
      FROM   dbo.BlackListDomain BLD 
             JOIN DBO.Subscriber S 
               ON S.Email like BLD.Domain 
              JOIN dbo.Subscriber s2  with(nolock)
              on s2.IdSubscriber = s.IdSubscriber
      WHERE  BLD.Marked = 0 AND  S2.IdSubscribersStatus IN (1,2)
	  EXCEPT SELECT IdSubscriber from @t

      UPDATE DBO.SubscriberXList WITH(ROWLOCK) 
      SET    Active = 0, 
             UTCDeleteDate = @date 
      FROM   DBO.SubscriberXList SXL 
             JOIN @t t 
               ON SXL.IdSubscriber = t.IDSubscriber 

      UPDATE DBO.Subscriber WITH(ROWLOCK) 
      SET    IdSubscribersStatus = 5, 
             UTCUnsubDate = @date,
             UnsubscriptionSubreason = 1
      FROM   DBO.Subscriber S 
             JOIN @t t 
               ON S.IdSubscriber = t.IdSubscriber 

      DELETE FROM DBO.FieldXSubscriber 
      FROM   DBO.FieldXSubscriber fxs 
             JOIN @t t 
               ON fxs.IdSubscriber = t.IDSubscriber 

      UPDATE dbo.BlackListEmail WITH(ROWLOCK) 
      SET    Marked = 1 
      WHERE  Marked = 0

      UPDATE dbo.BlackListDomain WITH(ROWLOCK) 
      SET    Marked = 1 
      WHERE  Marked = 0

  END TRY 

  BEGIN CATCH 
      PRINT( 'Error en [Mark_SubscribersBlackList]' ) 
  END CATCH