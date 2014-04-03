--4216

-- ALTERS TABLE TO SUPPORT NEW COLUMNS
ALTER TABLE AccountingEntry
ADD	AuthorizationNumber  VARCHAR (250)   NULL,
	InvoiceNumber     INT			  NULL,
	AccountingTypeDescription VARCHAR (250) NULL
GO

-- UPDATES THE ENTRIES TO HAVE A DESCRIPTION
	  UPDATE AccountingEntry SET AccountingTypeDescription = 'Invoice' WHERE AccountEntryType = 'I'
	  UPDATE AccountingEntry SET AccountingTypeDescription = 'CC Payment' WHERE AccountEntryType = 'P' AND PaymentEntryType = 'P'
	  UPDATE AccountingEntry SET AccountingTypeDescription = 'Credit Note' WHERE AccountEntryType = 'P' AND PaymentEntryType = 'N'



	-- ALTERS THE CURRENT INVOICES IN THE DATABASE TO HAVE THE 
	-- INVOICENUMBER SET CORRECTLY

	DECLARE @IdAccountingEntry INT, @InvoiceNumber INT

	DECLARE AccountingEntryCursor CURSOR FOR 
	SELECT IdAccountingEntry FROM AccountingEntry
	WHERE AccountEntryType = 'I' AND AccountingTypeDescription = 'Invoice'

	OPEN AccountingEntryCursor

	FETCH NEXT FROM AccountingEntryCursor 
	INTO @IdAccountingEntry

	SET @InvoiceNumber = 1
	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE AccountingEntry
		SET InvoiceNumber = @InvoiceNumber
		WHERE IdAccountingEntry = @IdAccountingEntry AND AccountingTypeDescription = 'Invoice'
		SET @IdAccountingEntry = @IdAccountingEntry + 1
		SET @InvoiceNumber = @InvoiceNumber +1
		FETCH NEXT FROM AccountingEntryCursor 
		INTO @IdAccountingEntry
	END 
	CLOSE AccountingEntryCursor;
	DEALLOCATE AccountingEntryCursor;
	GO

	-- CREATION OF TRIGGER TO AUTO INCREMENT INVOICE NUMBER EVERYTIME 
	-- AN ACCOUNTING ENTRY OF TYPE INVOICE IS INSERTED TO THE TABLE

	CREATE TRIGGER IncrementInvoiceNumber 
	   ON  AccountingEntry
	   AFTER INSERT
	AS 
	BEGIN
		SET NOCOUNT ON;
		DECLARE @insertedId INT;
		SELECT TOP(1) @insertedId = IdAccountingEntry FROM AccountingEntry ORDER BY IdAccountingEntry DESC;
		UPDATE AccountingEntry SET InvoiceNumber = ( SELECT TOP(1) InvoiceNumber FROM AccountingEntry
													 ORDER BY InvoiceNumber DESC	
													) + 1
							   WHERE IdAccountingEntry = @insertedId AND AccountingTypeDescription = 'Invoice';

	END
	GO

	--3987

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

			--Actualizo los envios para la camapaña 
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

	--UPDATE campaigns already sent

	update Campaign 
	set    AmountSentSubscribers = (select ISNULL(COUNT(1), 0) 
									from   CampaignDeliveriesOpenInfo WITH(NOLOCK) 
									where  CampaignDeliveriesOpenInfo.IdCampaign =  Campaign.IdCampaign)
	WHERE  AmountSentSubscribers IS NULL AND Status = 5
	GO

	--4254

	CREATE PROCEDURE [dbo].[Security_IsClientMigratedAndPayed_G]
	@IdUser int  
	AS
	SELECT * FROM [User] U WITH(NOLOCK)  
	WHERE U.IdUser = @IdUser
	AND IdCurrentBillingCredit IS NOT NULL
	AND U.MigrationState IS NOT NULL
	GO


	--4257

	ALTER PROCEDURE [dbo].[Client_G] @IDUser int 
	AS 
		SELECT u.IdUser, 
			   FirstName, 
			   LastName, 
			   Address, 
			   '', 
			   PhoneNumber, 
			   '', 
			   Company, 
			   Email, 
			   CityName, 
			   u.IdState, 
			   ZipCode, 
			   '', 
			   Email, 
			   [Password], 
			   1, 
			   IdIndustry, 
			   u.CCNumber, 
			   u.CCExpMonth, 
			   u.CCExpYear, 
			   u.CCHolderFullName, 
			   u.IDCCType, 
			   s.IdCountry, 
			   IdUserTimeZone, 
			   u.CCVerification, 
			   0, 
			   bc.IdUserTypePlan, 
			   0, 
			   Promotioncode, 
			   BillingFirstName, 
			   BillingLastName, 
			   BillingPhone, 
			   BillingFax, 
			   BillingAddress, 
			   BillingCity, 
			   IDBillingState, 
			   BillingZip, 
			   b.IdCountry, 
			   AllowContact, 
			   NonProfitOrganization, 
			   0, 
			   UTCRegisterDate, 
			   0, 
			   IdLanguage, 
			   0, 
			   PaymentMethod, 
			   APIKey, 
			   0, 
			   d.Domain, 
			   0, 
			   0, 
			   0, 
			   '', 
			   '', 
			   IdAmountMonthlyEmails, 
			   AccountValidation, 
			   website, 
			   0, 
			   0, 
			   PasswordResetCodeDate 
		FROM   [User] u WITH(NOLOCK) 
			   LEFT JOIN [BillingCredits] bc WITH(NOLOCK) 
					  ON bc.IdBillingCredit = u.IdCurrentBillingCredit 
			   LEFT JOIN [State] s WITH(NOLOCK) 
					  ON s.IdState = u.IdState 
			   LEFT JOIN [State] b WITH(NOLOCK) 
					  ON b.IdState = u.IdBillingState 
			   LEFT JOIN DomainKeyInformation d WITH(NOLOCK) 
					  ON u.IdUser = d.IdUser AND d.IsDomainKeyActive = 1
		WHERE  u.IdUser = @IDUser
	GO


