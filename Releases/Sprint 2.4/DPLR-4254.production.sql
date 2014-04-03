CREATE PROCEDURE [dbo].[Security_IsClientMigratedAndPayed_G]
@IdUser int  
AS
SELECT * FROM [User] U WITH(NOLOCK)  
WHERE U.IdUser = @IdUser
AND IdCurrentBillingCredit IS NOT NULL
AND U.MigrationState IS NOT NULL
GO
