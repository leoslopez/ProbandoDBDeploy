CREATE PROCEDURE [dbo].[AmountSubscribersByClientID_GA] (@IdUser int) 
AS 
    SELECT COUNT(S.IDSubscriber) 
    FROM   Subscriber S WITH(NOLOCK) 
    WHERE  S.IdUser = @IdUser 

GO 