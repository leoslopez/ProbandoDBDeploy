
CREATE PROCEDURE [dbo].[ABTestCampaigns_OnDateForSend] 
AS 
  BEGIN 
      select IdCampaign 
      from   Campaign c WITH(NOLOCK) 
      where  TestABCategory = 3 
             AND Status = 12 
             AND c.UTCScheduleDate <= getutcdate() 
  END