/*CREATE PROCEDURE [dbo].[ABTestCampaigns_OnDateForSend_UP]
AS
BEGIN
	BEGIN
		select IdCampaign from Campaign c
		where TestABCategory = 3 AND
		Status = 12 AND
		DATEDIFF(minute,c.UTCScheduleDate,getutcdate()) >= 0
	END
END*/