CREATE TYPE TypeLinkTracking AS TABLE (
			CountOpens INT,
			IdCampaign INT,
		    IdLink INT,
		 	IdSubscriber INT,
		    OpenDate DateTime		
		)