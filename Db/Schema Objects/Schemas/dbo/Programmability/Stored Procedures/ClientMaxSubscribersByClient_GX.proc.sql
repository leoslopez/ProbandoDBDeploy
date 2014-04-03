CREATE PROCEDURE [dbo].[ClientMaxSubscribersByClient_GX] 
@IdUser int 
AS 
SET NOCOUNT ON

SELECT MaxSubscribers 
FROM   [User] WITH(NOLOCK) 
WHERE  IdUser = @IdUser 

GO 