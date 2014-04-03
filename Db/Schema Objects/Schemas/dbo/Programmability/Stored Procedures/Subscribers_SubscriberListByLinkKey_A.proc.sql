/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberListByLinkKey_A]    Script Date: 08/07/2013 11:44:21 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberListByLinkKey_A]
@IdCampaign INT,
@IdLink INT,
@Name VARCHAR(300),
@Filter VARCHAR(200)
AS
DECLARE @IdSubscriberList int
BEGIN TRY
	BEGIN TRAN
	INSERT INTO dbo.SubscribersList
	([Name], IdUser, Active, UTCCreationDate, IdLabel, [SubscribersListStatus])
	SELECT @Name, C.IdUser, 1, GetDate(), 1, 1
	FROM Campaign C WITH(NOLOCK)
	WHERE IdCampaign = @IdCampaign
	
	SELECT @IdSubscriberList = SCOPE_IDENTITY()
	
	INSERT INTO [dbo].[SubscribersListFilter]
		(IdSubscribersList, IdSubscribersListSource, LeftCriteria, RightCriteria, Condition, Active)
        SELECT @IdSubscriberList, @IdCampaign, @filter, 'Clicked', @IdLink, 1
	
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH