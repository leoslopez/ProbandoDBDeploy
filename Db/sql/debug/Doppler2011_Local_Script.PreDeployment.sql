/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SocialNetworkAutoPublishXCampaign]') AND type in (N'U'))
BEGIN
	IF NOT EXISTS(
		SELECT *
		FROM SYS.OBJECTS T inner join SYS.COLUMNS C ON T.object_id = C.object_id 
		WHERE T.name = 'SocialNetworkAutoPublishXCampaign' 
		AND 
		(C.name = 'AccessToken' OR C.name = 'SecretToken')
	) 
	BEGIN 
		DELETE FROM SocialNetworkAutoPublishXCampaign
	END
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SocialNetworkAutoPublishXUser]') AND type in (N'U'))
BEGIN
	IF NOT EXISTS(
		SELECT *
		FROM SYS.OBJECTS T inner join SYS.COLUMNS C ON T.object_id = C.object_id 
		WHERE T.name = 'SocialNetworkAutoPublishXUser' 
		AND 
		(C.name = 'AccessToken' OR C.name = 'SecretToken')
	) 
	BEGIN 
		DELETE FROM SocialNetworkAutoPublishXUser
	END
END

IF EXISTS (SELECT * 
  FROM sys.foreign_keys 
   WHERE NAME = N'FK_ReplicatedCampaign_Campaign'
)
BEGIN
 ALTER TABLE Campaign
 DROP CONSTRAINT FK_ReplicatedCampaign_Campaign
END

IF EXISTS (SELECT * 
  FROM sys.foreign_keys 
   WHERE NAME = N'FK_ReplicatedReplicatedCampaign_ReplicatedCampaign'
)

BEGIN
 ALTER TABLE Campaign
 DROP CONSTRAINT FK_ReplicatedReplicatedCampaign_ReplicatedCampaign
END

IF EXISTS (select * from sys.columns where Name = N'IdParentReplicatedCampaign' )
BEGIN
ALTER TABLE [dbo].[Campaign] DROP COLUMN IdParentReplicatedCampaign
END

IF NOT EXISTS (select * from sys.columns where Name = N'ActivationDate' )
BEGIN 
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BillingCredits]'))
		BEGIN
			DELETE FROM BillingCredits
		END
END

IF NOT EXISTS (select * from sys.columns where Name = N'Fee' or Name = N'Discount' or Name = N'DiscountExtraEmail')
BEGIN 
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BillingCredits]'))
		BEGIN
			DELETE FROM MovementsCredits
			DELETE FROM BillingCredits
		END
END

IF EXISTS (select * from sys.objects o JOIN sys.columns c ON o.object_id = c.object_id WHERE o.name = 'Campaign' AND o.type in (N'U') AND c.name = 'Queued')
BEGIN
	UPDATE Campaign
	SET Queued = 0
END

IF EXISTS (select * from sys.columns where Name = N'Concept' )
BEGIN 
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MovementsCredits]'))
		BEGIN
			ALTER TABLE MovementsCredits
			DROP COLUMN Concept 
		END
END

IF EXISTS (select * from sys.columns where Name = N'MaxSubscribersSentEmailToAdmin' )
BEGIN 
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User]'))
		BEGIN
			ALTER TABLE [User]
			DROP CONSTRAINT DF_User_MaxSubscribersSentEmailToAdmin

			ALTER TABLE  [User]
			DROP COLUMN MaxSubscribersSentEmailToAdmin 
		END
END

IF EXISTS (select * from sys.columns where Name = N'SubscribersLimitReached' )
BEGIN 
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User]'))
		BEGIN
			ALTER TABLE [User]
			DROP CONSTRAINT DF_User_SubscribersLimitReached

			ALTER TABLE [User]
			DROP COLUMN SubscribersLimitReached
		END
END
