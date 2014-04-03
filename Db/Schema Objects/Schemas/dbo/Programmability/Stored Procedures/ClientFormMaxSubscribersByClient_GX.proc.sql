CREATE PROCEDURE [dbo].[ClientFormMaxSubscribersByClient_GX]
@IdUser int
AS
SET NOCOUNT ON

SELECT 1--FormMaxsubscribers
FROM [User] u WITH(NOLOCK)
WHERE u.IdUser = @IdUser
GO