--Modify SP to update all campaigns amount sent
ALTER PROCEDURE [dbo].[Common_CampaignCredits_UP] @IdCampaign int, @NeedMovements int
AS 
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

      SET @enviosTotal=0 
      SET @enviosCampaign=0 
      SET @cobrado=0 
      SET @PartialBalance=0 
      SET @idReplicated=0 
      SET @testABCategory=0 

		SELECT @idTestAB = ISNULL(Campaign.IdTestAB,0), @testABCategory = ISNULL(Campaign.TestABCategory,0) FROM Campaign WHERE Campaign.IdCampaign = @IdCampaign

		UPDATE Campaign WITH(ROWLOCK) 
		SET    UTCSentDate = getUTCdate() 
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


      IF((@idTestAB = 0 OR (@idTestAB > 0 AND @testABCategory = 3)) AND  @enviosTotal > 0  AND @NeedMovements = 1) 
        BEGIN 
            
		--Actualizo los envios para la camapaña 
        update Campaign 
        set    AmountSentSubscribers = @enviosCampaign 
        WHERE  IdCampaign = @IdCampaign 

            select @PartialBalance = ISNULL(PartialBalance, 0) 
            from   dbo.[MovementsCredits] WITH(NOLOCK) 
            where  IdMovementCredit = (SELECT MAX(IdMovementCredit) 
                                       from   dbo.[MovementsCredits] m WITH( 
                                              NOLOCK ) 
                                              JOIN Campaign c 
                                                ON m.Iduser = c.IdUser 
                                       WHERE  c.IdCampaign = @IdCampaign) 

            select @cobrado = ISNULL(CreditsQty, 0) 
            from   dbo.[MovementsCredits] WITH(NOLOCK) 
            where  IdCampaign = @IdCampaign 

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
                         GETUTCDATE(), 
                         @dif, 
                         @IdCampaign, 
                         @PartialBalance + @dif, 
                         'Adjustment Sent Campaign: ' + c.name,
						 'Ajuste Envío Campaña: ' + c.name 
                  from   Campaign c 
                  WHERE  c.IdCampaign = @IdCampaign 
              END 
        END 

      --Actualizo si tiene campañas replicadas. 
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


      --Actualizo el estado de la campaña 
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
