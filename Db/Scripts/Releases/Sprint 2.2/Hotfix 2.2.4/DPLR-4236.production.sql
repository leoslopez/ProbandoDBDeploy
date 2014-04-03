begin tran UpdatePassword
UPDATE [User] SET Password = LOWER(Password) WHERE MigrationState IS NOT NULL
commit tran UpdatePassword

Begin tran
ALTER TABLE [dbo].[Subscriber] 
	DROP COLUMN UTCLstOpen
commit




