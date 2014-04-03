PRINT N'Altering [dbo].[BlackListDomain]...';


GO
ALTER TABLE [dbo].[BlackListDomain]
    ADD [Marked]          BIT CONSTRAINT [DF_BlackListDomain_Marked] DEFAULT ((0)) NOT NULL,
        [IsInListProcess] BIT CONSTRAINT [DF_BlackListDomain_IsInListProcess] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Altering [dbo].[BlackListEmail]...';


GO
ALTER TABLE [dbo].[BlackListEmail]
    ADD [Marked]          BIT CONSTRAINT [DF_BlackListEmail_Marked] DEFAULT ((0)) NOT NULL,
        [IsInListProcess] BIT CONSTRAINT [DF_BlackListEmail_IsInListProcess] DEFAULT ((0)) NOT NULL;


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

                      INSERT INTO dbo.CampaignDeliveriesOpenInfo WITH(PAGLock) 
                                  (IdCampaign, 
                                   IdSubscriber, 
                                   [Count], 
                                   [Date], 
                                   IdDeliveryStatus) 
                      SELECT DISTINCT @Idcampaign, 
                                      SXL.IDSubscriber, 
                                      0, 
                                      @date, 
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

                            INSERT INTO dbo.CampaignDeliveriesOpenInfo WITH(PAGLock) 
                                        (IdCampaign, 
                                         IdSubscriber, 
                                         Count, 
                                         Date, 
                                         IdDeliveryStatus) 
                            SELECT @Idcampaign, 
                                   SXL.IDSubscriber, 
                                   0, 
                                   @date, 
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
             UTCUnsubDate = @date 
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
GO
PRINT N'Creating [dbo].[BlackListDomainAdded]...';


GO


CREATE PROCEDURE [dbo].[BlackListDomainAdded] 
AS 
    DECLARE @Domains TABLE 
      ( 
         Domain VARCHAR(200) 
      ) 

    INSERT INTO @Domains 
                (Domain) 
    SELECT Domain 
    FROM   dbo.BlackListDomain 
    WHERE  IsInListProcess = 0 

    UPDATE dbo.BlackListDomain 
    SET    IsInListProcess = 1 
    FROM   dbo.BlackListDomain bld 
           JOIN @Domains d 
             ON bld.Domain = d.Domain 

    SELECT Domain 
    FROM   @Domains
GO
PRINT N'Creating [dbo].[BlackListEmailAdded]...';


GO

CREATE PROCEDURE [dbo].[BlackListEmailAdded] 
AS 
    DECLARE @Emails TABLE 
      ( 
         Email VARCHAR(200) 
      ) 

    INSERT INTO @Emails 
                (Email) 
    SELECT Email 
    FROM   dbo.BlackListEmail 
    WHERE  IsInListProcess = 0 

    UPDATE dbo.BlackListEmail 
    SET    IsInListProcess = 1 
    FROM   dbo.BlackListEmail bld 
           JOIN @Emails d 
             ON bld.Email = d.Email 

    SELECT Email 
    FROM   @Emails
GO
