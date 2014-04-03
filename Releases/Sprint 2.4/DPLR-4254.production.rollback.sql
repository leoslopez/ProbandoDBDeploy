IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Security_IsClientMigratedAndPayed_G]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Security_IsClientMigratedAndPayed_G]
GO