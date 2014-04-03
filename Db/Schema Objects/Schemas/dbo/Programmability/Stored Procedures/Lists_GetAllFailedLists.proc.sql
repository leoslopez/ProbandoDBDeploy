
CREATE PROCEDURE [dbo].[Lists_GetAllFailedLists]
AS
BEGIN
	BEGIN
		SELECT IdImportTask FROM 
			ImportTask it
			JOIN dbo.ImportRequest ir on it.IdImportRequest = ir.IdImportRequest
			JOIN dbo.SubscribersList sl on ir.IdSubscriberList = sl.IdSubscribersList
		WHERE Status = 5 AND NumberOfAttempts < 3 and sl.Active = 1
	END
END