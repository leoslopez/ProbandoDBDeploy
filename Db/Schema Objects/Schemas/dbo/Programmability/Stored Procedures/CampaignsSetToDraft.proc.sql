CREATE PROCEDURE [dbo].[CampaignsSetToDraft] @IdUser int 
AS 
SET NOCOUNT ON

UPDATE Campaign WITH(ROWLOCK) 
SET    [Status] = 1 
WHERE  IdUser = @IdUser AND [Status] in ( 4, 7, 8 ) 

GO 