-- =============================================
-- Pre-deployment script to fix social networks table.
-- =============================================
IF NOT EXISTS 
( 
	SELECT * FROM syscolumns 
	WHERE id = OBJECT_ID('SocialNetwork')
	AND name = 'SortOrder'
)
BEGIN
	PRINT N'Altering [dbo].[SocialNetwork]...'
	ALTER TABLE SocialNetwork
	ADD SortOrder TINYINT NULL
END
GO
BEGIN
	PRINT N'Updating [dbo].[SocialNetwork]...'
	UPDATE SocialNetwork
	SET SortOrder = 1 WHERE Name = N'twitter'
	UPDATE SocialNetwork
	SET SortOrder = 2 WHERE Name = N'facebook'
	UPDATE SocialNetwork
	SET SortOrder = 3 WHERE Name = N'linkedin'
	UPDATE SocialNetwork
	SET SortOrder = 4 WHERE Name = N'googlemas'
	UPDATE SocialNetwork
	SET SortOrder = 5 WHERE Name = N'pinterest'
	UPDATE SocialNetwork
	SET SortOrder = 6 WHERE Name = N'tumblr'
	UPDATE SocialNetwork
	SET SortOrder = 7 WHERE Name = N'blogger'
	UPDATE SocialNetwork
	SET SortOrder = 8 WHERE Name = N'meneame'
	UPDATE SocialNetwork
	SET SortOrder = 9 WHERE Name = N'reddit'
	UPDATE SocialNetwork
	SET SortOrder = 10 WHERE Name = N'digg'
	UPDATE SocialNetwork
	SET SortOrder = 11 WHERE Name = N'delicious'
	UPDATE SocialNetwork
	SET SortOrder = 12, Active = 0 WHERE Name = N'google'
	UPDATE SocialNetwork
	SET SortOrder = 13, Active = 0 WHERE Name = N'googlebuzz'
	UPDATE SocialNetwork
	SET SortOrder = 14, Active = 0 WHERE Name = N'myspace'
	UPDATE SocialNetwork
	SET SortOrder = 15, Active = 0 WHERE Name = N'technorati'
	UPDATE SocialNetwork
	SET SortOrder = 16, Active = 0 WHERE Name = N'stumbleupon'
	UPDATE SocialNetwork
	SET SortOrder = 17, Active = 0 WHERE Name = N'posterous'
	UPDATE SocialNetwork
	SET SortOrder = 18, Active = 0 WHERE Name = N'orkut'
	UPDATE SocialNetwork
	SET SortOrder = 19, Active = 0 WHERE Name = N'windowslive'
	UPDATE SocialNetwork
	SET SortOrder = 20, Active = 0 WHERE Name = N'viadeo'
	UPDATE SocialNetwork
	SET SortOrder = 21, Active = 0 WHERE Name = N'hootsuite'
	UPDATE SocialNetwork
	SET SortOrder = 22, Active = 0 WHERE Name = N'pingfm'
	UPDATE SocialNetwork
	SET SortOrder = 23, Active = 0 WHERE Name = N'wordpress'
	UPDATE SocialNetwork
	SET SortOrder = 24, Active = 0 WHERE Name = N'other'


	PRINT N'Altering [dbo].[SocialNetwork]...'
	ALTER TABLE SocialNetwork
	ALTER COLUMN SortOrder TINYINT NOT NULL
END