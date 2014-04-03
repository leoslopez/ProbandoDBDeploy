



CREATE PROCEDURE [dbo].[TestABCampaignsToCreateSamplingLists] 
AS
declare @date datetime
set @date=getutcdate()

SELECT DISTINCT c.IdTestAB
FROM dbo.Campaign c WITH(NOLOCK) 
INNER JOIN
dbo.Campaign a 
ON c.IdTestAB=a.IdTestAB
WHERE c.Status=17 AND (DATEDIFF(second,a.UTCScheduleDate,GETUTCDATE()) > =0)