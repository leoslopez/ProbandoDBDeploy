﻿CREATE PROCEDURE [dbo].[DMSConfigById_GX] @IdDMS int
AS
BEGIN
  SELECT * FROM DMSConfig
  WHERE IdDMS = @IdDMS
END