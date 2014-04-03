IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Campaign]') AND name = N'IX_Campaign_User')
DROP INDEX [IX_Campaign_User] ON [dbo].[Campaign] WITH ( ONLINE = OFF )
GO

ALTER TABLE [dbo].[Campaign] ALTER COLUMN Subject NVARCHAR(100)
GO


/****** Object:  Index [IX_Campaign_User]    Script Date: 10/01/2013 17:32:37 ******/
CREATE NONCLUSTERED INDEX [IX_Campaign_User] ON [dbo].[Campaign] 
(
	[IdUser] ASC,
	[Active] ASC,
	[Status] ASC,
	[IdCampaign] ASC
)
INCLUDE ( [UTCSentDate],
[Name],
[Subject]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Campaign]
GO
