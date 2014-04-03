/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberListByCampaignAndDate_A]    Script Date: 08/07/2013 11:43:36 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberListByCampaignAndDate_A]
@IdCampaign INT,
@Date DATETIME,
@Name VARCHAR(300)

AS  
DECLARE @IDSubscriberList INT
BEGIN TRY
	BEGIN TRAN
	
	INSERT INTO dbo.SubscribersList
	([Name], IdUser, Active, UTCCreationDate, IdLabel, [SubscribersListStatus])
	SELECT @Name, C.IdUser, 1, GetDate(), 1, 1
	FROM Campaign C WITH(NOLOCK)
	WHERE IdCampaign = @IdCampaign
	
	SELECT @IDSubscriberList = SCOPE_IDENTITY()
	
	INSERT INTO [dbo].[SubscribersListFilter]
	(IdSubscribersList, IdSubscribersListSource, LeftCriteria, RightCriteria, Condition, Active)
	SELECT @IdSubscriberList, @IdCampaign, CONVERT(VARCHAR(10), @Date, 101), 'DateOpened', '=', 1

	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH