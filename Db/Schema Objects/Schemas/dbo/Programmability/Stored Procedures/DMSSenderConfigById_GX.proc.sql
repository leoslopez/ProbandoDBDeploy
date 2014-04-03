CREATE PROCEDURE [dbo].[DMSSenderConfigById_GX] @IdDMS int
AS
BEGIN
  SELECT * FROM DMSSenderInfoConfig SIC
  JOIN DMSSenderConfig SC 
  ON SC.IdDMSSenderConfig = SIC.IdDMSSenderConfig
  AND SC.Type = SIC.Type
  AND  SC.IdDMS = SIC.IdDMS
  WHERE SIC.IdDMS = @IdDMS
  ORDER BY SC.IdDMSSenderConfig
END