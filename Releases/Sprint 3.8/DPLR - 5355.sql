ALTER TABLE dbo.ViewerSection
ALTER COLUMN Name VARCHAR(200) NOT NULL

UPDATE dbo.ViewerSection
SET Name = 'Acceso completo a Reportes' WHERE IdSection = 1
