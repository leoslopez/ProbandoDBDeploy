CREATE PROC [dbo].[ClientSubscribersLimitReachedByClient_GX] 
@IdUser int 
AS 
SET NOCOUNT ON

SELECT IsSubscribersLimitReached 
FROM   [User] WITH(NOLOCK) 
WHERE  IdUser = @IdUser 

GO 