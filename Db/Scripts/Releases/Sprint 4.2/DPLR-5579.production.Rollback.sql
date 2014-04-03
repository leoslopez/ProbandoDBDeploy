PRINT N'Dropping DF_BlackListDomain_IsInListProcess...';


GO
ALTER TABLE [dbo].[BlackListDomain] DROP CONSTRAINT [DF_BlackListDomain_IsInListProcess];


GO
PRINT N'Dropping DF_BlackListDomain_Marked...';


GO
ALTER TABLE [dbo].[BlackListDomain] DROP CONSTRAINT [DF_BlackListDomain_Marked];


GO
PRINT N'Dropping DF_BlackListEmail_IsInListProcess...';


GO
ALTER TABLE [dbo].[BlackListEmail] DROP CONSTRAINT [DF_BlackListEmail_IsInListProcess];


GO
PRINT N'Dropping DF_BlackListEmail_Marked...';


GO
ALTER TABLE [dbo].[BlackListEmail] DROP CONSTRAINT [DF_BlackListEmail_Marked];


GO
PRINT N'Dropping [dbo].[BlackListDomainAdded]...';


GO
DROP PROCEDURE [dbo].[BlackListDomainAdded];


GO
PRINT N'Dropping [dbo].[BlackListEmailAdded]...';


GO
DROP PROCEDURE [dbo].[BlackListEmailAdded];


GO
PRINT N'Altering [dbo].[BlackListDomain]...';


GO
ALTER TABLE [dbo].[BlackListDomain] DROP COLUMN [IsInListProcess], COLUMN [Marked];


GO
PRINT N'Altering [dbo].[BlackListEmail]...';


GO
ALTER TABLE [dbo].[BlackListEmail] DROP COLUMN [IsInListProcess], COLUMN [Marked];


GO
PRINT N'Altering [dbo].[CampaignStatus_UP]...';


GO

ALTER PROCEDURE [dbo].[CampaignStatus_UP] @IdCampaign    INT, 
                                          @Status        INT, 
                                          @needMovements INT 
AS 
    SET NOCOUNT ON 

    DECLARE @date DATETIME 
    DECLARE @IDsubscriber BIGINT 
    DECLARE @cant INT 
    -- No tomar campaign descomentar ---- (3 lineas)      
    ----IF (@IdCampaign<>1031271)      
    ----begin      
    DECLARE @t TABLE 
      ( 
         Email        VARCHAR(100), 
         IDSubscriber BIGINT, 
         LanguageID   INT 
         UNIQUE CLUSTERED (IDSubscriber) 
      ) 
    DECLARE @BckL TABLE 
      ( 
         IDSubscriber BIGINT 
         UNIQUE CLUSTERED (IDSubscriber) 
      ) 

    IF( @Status = 10 ) 
      BEGIN 
          IF( @IdCampaign <> 1054172 ) 
            BEGIN 
                IF EXISTS(SELECT 1 
                          FROM   CampaignBig WITH(ROWLOCK) 
                          WHERE  IDCampaign = @IdCampaign 
                                 AND cant > 500000 
                                 AND active = 1) 
                  PRINT( 'Big campain' ) 
                ELSE 
                  BEGIN 
                      SET @date=getUTCdate() 

                      INSERT INTO @t 
                      SELECT DISTINCT S.Email, 
                                      S.IdSubscriber, 
                                      0 
                      FROM   dbo.SubscribersListXCampaign SLXC WITH (NOLOCK) 
                             JOIN dbo.SubscribersList SL WITH (NOLOCK) 
                               ON SLXC.IdSubscribersList = SL.IdSubscribersList 
                             JOIN dbo.SubscriberXList SXL WITH (NOLOCK) 
                               ON SL.IdSubscribersList = SXL.IdSubscribersList 
                             JOIN Subscriber S WITH (NOLOCK) 
                               ON S.IdSubscriber = SXL.IdSubscriber 
                      WHERE  ( SLXC.Idcampaign = @Idcampaign ) 
                             AND ( SL.Active = 1 ) 
                             AND ( S.IdSubscribersStatus < 3 ) 
                             AND ( SXL.Active = 1 ) 

                      --- BlackList Verification                                                      
                      INSERT INTO @BckL 
                      SELECT DISTINCT T.IDSubscriber 
                      FROM   @t T 
                             JOIN dbo.BlacklistEmail BLE WITH(NOLOCK) 
                               ON T.Email = BLE.email 

                      DELETE FROM @t 
                      FROM   @t T 
                             JOIN @BckL B 
                               ON T.IDSubscriber = B.IDSubscriber 

                      INSERT INTO @BckL 
                      SELECT DISTINCT T.IDSubscriber 
                      FROM   @t T 
                             JOIN dbo.BlacklistDomain BLD WITH(NOLOCK) 
                               ON T.Email LIKE BLD.Domain 

                      DELETE FROM @t 
                      FROM   @t T 
                             JOIN @BckL B 
                               ON T.IDSubscriber = B.IDSubscriber 

                      INSERT INTO SubscriberBlackList WITH(ROWLOCK) 
                      SELECT DISTINCT IDSubscriber, 
                                      0, 
                                      NULL 
                      FROM   @BckL 

                      INSERT INTO dbo.CampaignDeliveriesOpenInfo WITH(PAGLock) 
                                  (IdCampaign, 
                                   IdSubscriber, 
                                   [Count], 
                                   [Date], 
                                   IdDeliveryStatus, 
                                   Sent) 
                      SELECT DISTINCT @Idcampaign, 
                                      T.IDSubscriber, 
                                      0, 
                                      @date, 
                                      0, 
                                      0 
                      FROM   @t T 

                      INSERT INTO dbo.CampaignXSubscriberStatus WITH(PAGLock) 
                                  (IdCampaign, 
                                   IdSubscriber, 
                                   Sent) 
                      SELECT DISTINCT @Idcampaign, 
                                      T.IDSubscriber, 
                                      0 
                      FROM   @t T 



                  END 
            END 

          UPDATE Campaign WITH(ROWLOCK) 
          SET    [Status] = 10 
          WHERE  IDcampaign = @IdCampaign 
      END -- (@newStatusid=10)           
    ELSE 
      BEGIN 
          IF( @Status = 5 ) 
            BEGIN 
                -- Aqui se debe poner la actualizacion           
                -- de envio y cobro (subscribers)          
                EXECUTE Common_CampaignCredits_UP 
                  @IdCampaign, 
                  @needMovements 

				DELETE FROM dbo.CampaignXSubscriberStatus
				WHERE IdCampaign = @IdCampaign

                -- Clients Gire guardamos Field uzado en la campaign           
                IF EXISTS(SELECT 1 
                          FROM   Campaign WITH(ROWLOCK) 
                          WHERE  IdCampaign = @IdCampaign 
                                 AND IdUser IN ( 17373, 12790 )) 
                  BEGIN 
                      INSERT INTO [CampaignFieldUsed] WITH(ROWLOCK) 
                      SELECT DISTINCT CDOI.IDcampaign, 
                                      CDOI.IdSubscriber, 
                                      CXF.IdField, 
                                      FXS.Value 
                      FROM   dbo.Campaign C WITH(NOLOCK) 
                             JOIN dbo.CampaignDeliveriesOpenInfo CDOI WITH(NOLOCK) 
                               ON C.IdCampaign = CDOI.IdCampaign 
                             JOIN ContentXField CXF WITH(NOLOCK) 
                               ON C.IdContent = CXF.IdContent 
                             JOIN dbo.FieldXSubscriber FXS WITH(NOLOCK) 
                               ON CDOI.IdSubscriber = FXS.IdSubscriber 
                                  AND CXF.IdField = FXS.IdField 
                      WHERE  C.IDcampaign = @IdCampaign 
                  END 
            END --(@Status=5)           
          ELSE --(@Status!=5)           
            BEGIN 
                -- BIG Campaigns           
                IF EXISTS(SELECT 1 
                          FROM   Campaign WITH(ROWLOCK) 
                          WHERE  IdCampaign = @IdCampaign 
                                 AND [Status] = 8) 
                   AND @Status = 4 
                   AND @IdCampaign <> 1054172 
                  BEGIN 
                      SET @cant=(SELECT COUNT(DISTINCT S.IdSubscriber) 
                                 FROM   dbo.SubscribersListXCampaign SLXC WITH (NOLOCK ) 
                                        JOIN dbo.SubscriberXList SXL WITH (NOLOCK) 
                                          ON SLXC.IdSubscribersList = SXL.IdSubscribersList 
                                        JOIN Subscriber S WITH (NOLOCK) 
                                          ON S.IdSubscriber = SXL.IdSubscriber 
                                 WHERE  ( SLXC.Idcampaign = @Idcampaign ) 
                                        AND ( S.IdSubscribersStatus < 3 ) 
                                        AND ( SXL.Active = 1 )) 

                      --print(@cant)           
                      IF( @cant > 500000 ) 
                        BEGIN 
                            SET @date=getUTCdate() 

                            INSERT INTO @t 
                            SELECT DISTINCT S.Email, 
                                            S.IdSubscriber, 
                                            0 
                            FROM   dbo.SubscribersListXCampaign SLXC WITH (NOLOCK) 
                                   JOIN dbo.SubscribersList SL WITH (NOLOCK) 
                                     ON SLXC.IdSubscribersList = SL.IdSubscribersList 
                                   JOIN dbo.SubscriberXList SXL WITH (NOLOCK) 
                                     ON SL.IdSubscribersList = SXL.IdSubscribersList 
                                   JOIN Subscriber S WITH (NOLOCK) 
                                     ON S.IdSubscriber = SXL.IdSubscriber 
                            WHERE  ( SLXC.Idcampaign = @Idcampaign ) 
                                   AND ( SL.Active = 1 ) 
                                   AND ( S.IdSubscribersStatus < 3 ) 
                                   AND ( SXL.Active = 1 ) 

                            --- BlackList Verification                                                      
                            INSERT INTO @BckL 
                            SELECT DISTINCT T.IDSubscriber 
                            FROM   @t T 
                                   JOIN dbo.BlacklistEmail BLE WITH(NOLOCK) 
                                     ON T.Email = BLE.email 

                            DELETE FROM @t 
                            FROM   @t T 
                                   JOIN @BckL B 
                                     ON T.IDSubscriber = B.IDSubscriber 

                            INSERT INTO @BckL 
                            SELECT DISTINCT T.IDSubscriber 
                            FROM   @t T 
                                   JOIN dbo.BlacklistDomain BLD WITH(NOLOCK) 
                                     ON T.Email LIKE BLD.Domain 

                            DELETE FROM @t 
                            FROM   @t T 
                                   JOIN @BckL B 
                                     ON T.IDSubscriber = B.IDSubscriber 

                            INSERT INTO SubscriberBlackList WITH(ROWLOCK) 
                            SELECT DISTINCT IDSubscriber, 
                                            0, 
                                            NULL 
                            FROM   @BckL 

                            INSERT INTO dbo.CampaignDeliveriesOpenInfo WITH(PAGLock) 
                                        (IdCampaign, 
                                         IdSubscriber, 
                                         Count, 
                                         Date, 
                                         IdDeliveryStatus, 
                                         Sent) 
                            SELECT @Idcampaign, 
                                   T.IDSubscriber, 
                                   0, 
                                   @date, 
                                   0, 
                                   0 
                            FROM   @t T 

							INSERT INTO dbo.CampaignXSubscriberStatus WITH(PAGLock) 
                                  (IdCampaign, 
                                   IdSubscriber, 
                                   Sent) 
							  SELECT DISTINCT @Idcampaign, 
											  T.IDSubscriber, 
											  0 
							  FROM   @t T 



                            INSERT INTO CampaignBig WITH(ROWLOCK) 
                            SELECT @IdCampaign, 
                                   @cant, 
                                   1 
                        END 
                  END 

                UPDATE Campaign WITH(ROWLOCK) 
                SET    [Status] = @Status 
                WHERE  IdCampaign = @IdCampaign 
            END 
      END
GO
PRINT N'Altering [dbo].[Mark_SubscribersBlackList]...';


GO

ALTER PROCEDURE [dbo].[Mark_SubscribersBlackList] 
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
      SELECT DISTINCT S1.IdSubscriber 
      FROM   SubscriberBlackList SBL 
             JOIN DBO.Subscriber S 
               ON S.IdSubscriber = SBL.IDSubscriber 
             JOIN DBO.Subscriber S1 
               ON S1.Email = S.Email 
      WHERE  SBL.Marked = 0 AND S1.IdSubscribersStatus IN (1,2)

      UPDATE DBO.SubscriberXList WITH(ROWLOCK) 
      SET    Active = 0, 
             UTCDeleteDate = @date 
      FROM   DBO.SubscriberXList SXL 
             JOIN @t t 
               ON SXL.IdSubscriber = t.IDSubscriber 

      UPDATE DBO.Subscriber WITH(ROWLOCK) 
      SET    IdSubscribersStatus = 5, 
             UTCUnsubDate = @date 
      FROM   DBO.Subscriber S 
             JOIN @t t 
               ON S.IdSubscriber = t.IdSubscriber 

      DELETE FROM DBO.FieldXSubscriber 
      FROM   DBO.FieldXSubscriber fxs 
             JOIN @t t 
               ON fxs.IdSubscriber = t.IDSubscriber 

      UPDATE SubscriberBlackList WITH(ROWLOCK) 
      SET    Marked = 1, 
             MarkedDate = @Date 
      WHERE  Marked = 0 
  END TRY 

  BEGIN CATCH 
      PRINT( 'Error en [Mark_SubscribersBlackList]' ) 
  END CATCH
GO
