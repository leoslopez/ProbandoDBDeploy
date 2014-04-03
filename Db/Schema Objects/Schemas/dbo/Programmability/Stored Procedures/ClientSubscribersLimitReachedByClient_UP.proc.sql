CREATE PROC [dbo].[ClientSubscribersLimitReachedByClient_UP] 
@IdUser  int, 
@Reached bit 
AS 
SET NOCOUNT ON

Update [User] WITH(ROWLOCK) 
SET    IsSubscribersLimitReached = @Reached 
WHERE  IdUser = @IdUser 

GO 