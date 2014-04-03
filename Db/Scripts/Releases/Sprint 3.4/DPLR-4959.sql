ALTER PROCEDURE [dbo].[Lists_GetAllStuckLists]
AS
BEGIN
	BEGIN
		SELECT it.IdImportTask, it.AmountImported FROM ImportTask it 
		JOIN ImportRequest ir ON it.IdImportRequest = ir.IdImportRequest
		JOIN SubscribersList sl ON ir.IdSubscriberList = sl.IdSubscribersList
		WHERE it.Status = 1 AND sl.SubscribersListStatus != 1
	END
END

DELETE FROM dbo.FieldMapping
FROM dbo.FieldMapping fm
JOIN dbo.ImportRequest ir on fm.IdImportRequest = ir.IdImportRequest
JOIN dbo.ImportTask it on ir.IdImportRequest = it.IdImportRequest
WHERE it.Status = 5 AND it.StartDate < DATEADD(day,-1, GETUTCDATE())

Update dbo.ImportTask
 SET Status = 2
FROM 
dbo.ImportTask it
JOIN dbo.ImportRequest ir on it.IdImportRequest = ir.IdImportRequest
JOIN dbo.SubscribersList sl on sl.IdSubscribersList = ir.IdSubscriberList
WHERE it.Status IN (1,5) AND it.StartDate < DATEADD(day,-5, GETUTCDATE()) and sl.SubscribersListStatus = 1