CREATE PROCEDURE [dbo].[Lists_GetAllStuckLists]
AS
BEGIN
	BEGIN
		SELECT it.IdImportTask, it.AmountImported FROM ImportTask it 
		JOIN ImportRequest ir ON it.IdImportRequest = ir.IdImportRequest
		JOIN SubscribersList sl ON ir.IdSubscriberList = sl.IdSubscribersList
		WHERE it.Status = 1 AND sl.SubscribersListStatus <> 1 AND sl.Active = 1
	END
END