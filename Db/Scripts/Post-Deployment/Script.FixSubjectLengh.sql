-- =============================================
-- Post deployment script to add all the correct Industries to the app(Spanish only)
-- =============================================
	
	USE Doppler2011_Local

	ALTER TABLE Campaign ALTER COLUMN Subject varchar(100)
