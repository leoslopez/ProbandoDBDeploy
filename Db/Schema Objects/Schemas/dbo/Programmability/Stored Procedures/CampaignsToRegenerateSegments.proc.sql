CREATE PROCEDURE [dbo].[CampaignsToRegenerateSegments] 
AS
SET NOCOUNT ON

declare @date datetime
set @date=getutcdate()

SELECT c.IdCampaign
FROM dbo.Campaign c WITH(NOLOCK) 
WHERE (c.Status = 7 AND c.UTCScheduleDate<@date 
OR c.Status=3)