ALTER TABLE [ImportTask]
ADD
     NumberOfAttempts INT NOT NULL DEFAULT 0,
     AmountImported INT NOT NULL DEFAULT 0
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [Lists_GetAllFailedLists]
AS
BEGIN
	BEGIN
		SELECT IdImportTask FROM ImportTask it
		WHERE it.Status = 5 AND NumberOfAttempts < 3
	END
END
GO

CREATE PROCEDURE [Lists_GetAllStuckLists]
AS
BEGIN
	BEGIN
		SELECT it.IdImportTask, it.AmountImported FROM ImportTask it
		WHERE it.Status = 1
	END
END
GO
