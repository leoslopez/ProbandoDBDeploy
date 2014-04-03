




CREATE PROCEDURE [dbo].[TestABCampaignsReadyToAdjust] 
AS
declare @date datetime
set @date=getutcdate()

SELECT DISTINCT c.IdCampaign
FROM dbo.Campaign c WITH(NOLOCK) 

WHERE c.Status=15