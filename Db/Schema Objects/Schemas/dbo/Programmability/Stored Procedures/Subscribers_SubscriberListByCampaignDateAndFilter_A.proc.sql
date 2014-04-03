/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberListByCampaignDateAndFilter_A]    Script Date: 08/07/2013 11:43:47 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberListByCampaignDateAndFilter_A]
@IdCampaign INT,
@Date DATETIME,
@Name VARCHAR(300),
@emailFilter varchar(50),
@firstnameFilter varchar(50),
@lastnameFilter varchar(50)
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
	SELECT @IdSubscriberList, @IdCampaign, @emailFilter+'#'+@firstnameFilter+'#'+@lastnameFilter, 'DateOpenedFilter', CONVERT(VARCHAR(10), @Date, 101),1

	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH