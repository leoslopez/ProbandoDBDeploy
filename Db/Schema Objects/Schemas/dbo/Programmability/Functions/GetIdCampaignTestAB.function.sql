CREATE FUNCTION [dbo].[GetIdCampaignTestAB] 
(
	@IdCampaign INT
)
RETURNS int
AS
BEGIN
	DECLARE @ReturnedIdCampaign INT
	SELECT @ReturnedIdCampaign = ISNULL(S.IdCampaign, C.IdCampaign)  
	FROM Campaign C WITH(NOLOCK)
	LEFT JOIN Campaign s WITH(NOLOCK)
	ON S.IdTestAB = C.IdTestAB AND s.TestABCategory = 3
	WHERE C.IdCampaign = @IdCampaign
	RETURN @ReturnedIdCampaign
END 

GO 