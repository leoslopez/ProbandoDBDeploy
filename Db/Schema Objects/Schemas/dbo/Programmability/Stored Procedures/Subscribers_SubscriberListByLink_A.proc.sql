/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberListByLink_A]    Script Date: 08/07/2013 11:44:10 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberListByLink_A]
@IdCampaign INT,
@IdLink INT,
@Name VARCHAR(300) 
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
        SELECT @IdSubscriberList, @IdCampaign, @IdLink, 'Clicked', '=', 1  
  
 COMMIT TRAN  
END TRY  
BEGIN CATCH  
 ROLLBACK TRAN  
END CATCH