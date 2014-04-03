CREATE FUNCTION [dbo].[GetTestABSet]
(
 @IdCampaign INT
)
RETURNS TABLE AS
RETURN (
SELECT IdCampaign FROM Campaign WHERE IdCampaign = @IdCampaign 
UNION 
SELECT ca.IdCampaign 
FROM Campaign c
JOIN Campaign ca
ON c.IdTestAB = ca.IdTestAB
WHERE c.IdCampaign = @IdCampaign
AND c.IdTestAB IS NOT NULL)