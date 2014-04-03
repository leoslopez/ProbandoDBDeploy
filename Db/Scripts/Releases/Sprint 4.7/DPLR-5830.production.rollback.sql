PRINT 'Drop constraint [FK_AccountCancellationReason_Resource] from [AccountCancellationReason] table'
ALTER TABLE [dbo].[AccountCancellationReason] DROP CONSTRAINT [FK_AccountCancellationReason_Resource]
GO

PRINT 'Drop constraint [FK_User_AccountCancellationReason] from [User] table'
ALTER TABLE [dbo].[User] DROP CONSTRAINT [FK_User_AccountCancellationReason]
GO

PRINT 'Drop [AccountCancellationReason] table'
DROP TABLE [dbo].[AccountCancellationReason]
GO

PRINT 'Delete from [Resource] records related to [AccountCancellationReason] table'
DELETE [dbo].[Resource] WHERE IdResource BETWEEN 8 AND 18 
GO

PRINT 'Drop [IdAccountCancellationReason] column from [User] table'
ALTER TABLE [dbo].[User] DROP COLUMN [IdAccountCancellationReason]
GO

PRINT 'Drop UpdateCampaignStatusForCanceledAccount stored procedure'
GO
DROP PROCEDURE UpdateCampaignStatusForCanceledAccount

GO
PRINT 'Delete from [AdminSection] the new section: Reports-Canceled Accounts'
DELETE [dbo].[AdminSection] WHERE [IdSection] = 29

GO
PRINT 'Delete from [AdminAccessRight] table the new section access right: Reports-Canceled Accounts'
DELETE [dbo].[AdminAccessRight] WHERE [IdAdmin] = 1 AND [IdSection] = 29