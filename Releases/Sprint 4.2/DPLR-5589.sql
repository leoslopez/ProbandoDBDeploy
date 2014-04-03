ALTER TABLE dbo.SubscribersList
ADD UTCLastSentDate datetime

GO

ALTER PROCEDURE [dbo].[Common_CampaignCredits_UP] 
@IdCampaign int, 
@NeedMovements int
AS 
SET NOCOUNT ON

BEGIN
  BEGIN TRY 
      BEGIN TRAN 

      DECLARE @enviosTotal INT 
      DECLARE @enviosCampaign INT 
      DECLARE @PartialBalance INT 
      DECLARE @cobrado INT 
      DECLARE @dif INT 
      DECLARE @idReplicated INT 
	  DECLARE @idTestAB INT
	  DECLARE @testABCategory INT
	  DECLARE @lastSentDate DATETIME

      SET @enviosTotal=0 
      SET @enviosCampaign=0 
      SET @cobrado=0 
      SET @PartialBalance=0 
      SET @idReplicated=0 
      SET @testABCategory=0 
	  SET @lastSentDate = getUTCdate()

		SELECT @idTestAB = ISNULL(Campaign.IdTestAB,0), @testABCategory = ISNULL(Campaign.TestABCategory,0) FROM Campaign WHERE Campaign.IdCampaign = @IdCampaign

		UPDATE Campaign WITH(ROWLOCK) 
		SET    UTCSentDate =  @lastSentDate
		WHERE  IDcampaign = @IdCampaign 

		select @enviosCampaign = ISNULL(COUNT(1), 0) 
		from   CampaignDeliveriesOpenInfo WITH(NOLOCK) 
		where  IdCampaign = @IdCampaign 

		SET @enviosTotal = @enviosCampaign

		IF( @idTestAB > 0)
			BEGIN
			  select @enviosTotal = ISNULL(COUNT(1), 0) 
			  from   CampaignDeliveriesOpenInfo WITH(NOLOCK)
			  where  IdCampaign IN (SELECT IdCampaign FROM Campaign WHERE IdTestAb = @idTestAB)
			END

        --Actualizo los envios para la camapa�a 
        update Campaign 
        set    AmountSentSubscribers = @enviosCampaign 
        WHERE  IdCampaign = @IdCampaign 

      IF((@idTestAB = 0 OR (@idTestAB > 0 AND @testABCategory = 3)) AND  @enviosTotal > 0  AND @NeedMovements = 1) 
        BEGIN 
            select @PartialBalance = ISNULL(PartialBalance, 0) 
            from   dbo.[MovementsCredits] WITH(NOLOCK) 
            where  IdMovementCredit = (SELECT MAX(IdMovementCredit) 
                                       from   dbo.[MovementsCredits] m WITH( 
                                              NOLOCK ) 
                                              JOIN Campaign c 
                                                ON m.Iduser = c.IdUser 
                                       WHERE  c.IdCampaign = @IdCampaign) 

            select TOP 1 @cobrado = ISNULL(CreditsQty, 0) 
            from   dbo.[MovementsCredits] WITH(NOLOCK) 
            where  IdCampaign = @IdCampaign 
			ORDER BY IdMovementCredit DESC

            SET @dif=@cobrado * (-1) - @enviosTotal

            IF( @dif <> 0 
                AND @dif <> @enviosTotal ) 
              BEGIN 
                  INSERT INTO MovementsCredits 
                              (IdUser, 
                               Date, 
                               CreditsQty, 
                               IdCampaign, 
                               PartialBalance, 
                               ConceptEnglish,
							   ConceptSpanish) 
                  SELECT c.IdUser, 
                         @lastSentDate, 
                         @dif, 
                         @IdCampaign, 
                         @PartialBalance + @dif, 
                         'Adjustment Sent Campaign: ' + c.name,
						 'Ajuste Env�o Campa�a: ' + c.name 
                  from   Campaign c 
                  WHERE  c.IdCampaign = @IdCampaign 
              END 
        END 

      --Actualizo si tiene campa�as replicadas. 
      select @idReplicated = ISNULL(IdCampaign, 0) 
      from   Campaign WITH(NOLOCK) 
      where  IdParentCampaign = @IdCampaign 

      IF( @idReplicated > 0 ) 
        BEGIN 
            UPDATE Campaign 
            SET    [Status] = 3, 
                   [Active] = 1 
            WHERE  IdCampaign = @idReplicated 
        END 

	  --Actualizo la ultima fecha de envio de las listas relacionadas a la campa�a

	  UPDATE dbo.SubscribersList
	  SET UTCLastSentDate = @lastSentDate
	  FROM dbo.SubscribersList sl
	  JOIN dbo.SubscribersListXCampaign slxc on sl.IdSubscribersList = slxc.IdSubscribersList
	  WHERE slxc.IdCampaign = @IdCampaign

      --Actualizo el estado de la campa�a 
      UPDATE Campaign WITH(ROWLOCK) 
      SET    [Status] = 5 
      WHERE  IdCampaign = @IdCampaign 

      COMMIT TRAN 
  END TRY 

  BEGIN CATCH 
      ROLLBACK TRAN 
  END CATCH 
END

GO

--Actualizar los LastSentDate no populados.
UPDATE dbo.SubscribersList 
SET    UTCLastSentDate = result.LastUse 
FROM   dbo.SubscribersList sl 
       JOIN (SELECT slxc.IdSubscribersList, 
                    MAX(c.UTCSentDate) LastUse 
             FROM   dbo.SubscribersList sl 
                    JOIN dbo.SubscribersListXCampaign slxc 
                      ON sl.IdSubscribersList = slxc.IdSubscribersList 
                    JOIN dbo.Campaign c 
                      ON slxc.IdCampaign = c.IdCampaign 
                    LEFT JOIN dbo.Campaign c2 
                           ON ( slxc.IdCampaign = c2.IdCampaign 
                                AND c.UTCSentDate > c2.UTCSentDate ) 
             WHERE  c2.IdCampaign IS NULL 
                    AND c.UTCSentDate IS NOT NULL 
             GROUP  BY slxc.IdSubscribersList) result 
         ON result.IdSubscribersList = sl.IdSubscribersList

GO