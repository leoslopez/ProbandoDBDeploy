CREATE TYPE TypeRegisterSocialOpen AS TABLE (
			CountOpens INT,
			IdCampaign INT,
			IdPlatform INT,
			IdSocialNetwork INT,
			IdSubscriber INT,
			IdUserMailAgent INT,
			IpAddress VARCHAR(100),
			IpNumber BIGINT,
			OpenDate DateTime
	)