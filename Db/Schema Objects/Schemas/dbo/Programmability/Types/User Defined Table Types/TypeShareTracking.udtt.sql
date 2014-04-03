CREATE TYPE [dbo].[TypeShareTracking] AS TABLE 
(
			CountOpens INT,
			IdCampaign INT,
			IdSocialNetwork INT,
	        IdSubscriber INT,
			OpenDate DateTime			
)