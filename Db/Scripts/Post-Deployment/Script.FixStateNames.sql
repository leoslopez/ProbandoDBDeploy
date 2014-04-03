-- =============================================
-- Post Deployment Script to fix names of States that has the substring "(see also separate entry..."
-- =============================================

USE Doppler2011_Local

UPDATE [dbo].[State]
SET Name = (SELECT CASE WHEN [Name] like '%(see also separate entry%' THEN SUBSTRING(Name, 0, CHARINDEX('(see also separate entry', Name))
			ELSE Name END 
			FROM [dbo].[State] AS stateAux
			WHERE [dbo].[State].IdState = stateAux.IdState)
WHERE [Name] like '%(see also separate entry%' 