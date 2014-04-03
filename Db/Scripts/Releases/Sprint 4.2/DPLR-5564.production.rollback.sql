IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMSSenderInfoConfig]'))
	DROP TABLE [dbo].[DMSSenderInfoConfig]
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMSSenderConfig]'))
	DROP TABLE [dbo].[DMSSenderConfig]
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMSConfig]'))
	DROP TABLE [dbo].[DMSConfig]
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMSConfigById_GX]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[DMSConfigById_GX]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMSSenderConfigById_GX]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[DMSSenderConfigById_GX]
GO


