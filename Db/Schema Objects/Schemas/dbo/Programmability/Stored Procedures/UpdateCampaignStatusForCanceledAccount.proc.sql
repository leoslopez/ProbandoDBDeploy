CREATE PROCEDURE UpdateCampaignStatusForCanceledAccount @IdUser INT
AS
BEGIN
	-- update status for campaigns in status ON_HOLD = 2, VERIFY_CREDITS = 3, SCHEDULED = 4, ANALIZE_SEGMENT = 7, READY_TO_VERIFY = 8
	UPDATE [dbo].[Campaign] 
		SET status = 1 
		WHERE IdUser = @IdUser AND IdTestAB IS NULL AND status IN (2, 3, 4, 7, 8)
	
	-- update status for TEST AB campaigns when tests were not sent yet
	UPDATE CR
		SET CR.status = 11 
		FROM Campaign CR
			INNER JOIN Campaign CA ON(CR.IdTestAB = CA.IdTestAB)
			INNER JOIN Campaign CB ON(CR.IdTestAB = CB.IdTestAB)
		WHERE CR.IdUser = @IdUser
		AND CR.IdTestAB IS NOT NULL
		AND CR.TestABCategory = 3 AND CR.status = 17
		AND CA.TestABCategory = 1 AND CA.Status = 11
		AND CB.TestABCategory = 2 AND CB.Status = 11
END