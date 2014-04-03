

ALTER TABLE [user]
ALTER COLUMN PhoneNumber varchar(20) null
GO
ALTER TABLE [user]
ALTER COLUMN Address varchar(50) null
GO
ALTER TABLE [user]
ALTER COLUMN GoogleAnalyticName varchar(50) null
GO
ALTER TABLE [dbo].[User]
    DROP COLUMN [MigrationState]
GO
DELETE FROM [dbo].Industry WHERE IdIndustry = 0
GO


DELETE FROM [dbo].[UserTimeZone] WHERE IdUserTimeZone IN (1,3,26,28,31,35)
GO


