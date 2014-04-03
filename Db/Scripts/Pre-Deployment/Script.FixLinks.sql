-- =============================================
-- Pre-deployment script to fix link data.
-- =============================================
IF NOT EXISTS 
( 
	SELECT * FROM syscolumns 
	WHERE id = OBJECT_ID('Link')
	AND name = 'IdCampaign'
)
BEGIN
	PRINT N'Altering [dbo].[Link]...'
	ALTER TABLE Link
	ADD IdCampaign INT NULL
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'LinkXContent'))
BEGIN
	PRINT N'Updating existing links...'
	UPDATE l
	SET IdCampaign = (SELECT IdContent FROM LinkXContent WHERE IdLink = l.IdLink)
	FROM Link l
	
	PRINT N'Deleting orphan links...'
	DELETE FROM Link
	WHERE IdCampaign IS NULL
	
	PRINT N'Altering [dbo].[Link]...'
	ALTER TABLE Link
	ALTER COLUMN IdCampaign INT NOT NULL
END