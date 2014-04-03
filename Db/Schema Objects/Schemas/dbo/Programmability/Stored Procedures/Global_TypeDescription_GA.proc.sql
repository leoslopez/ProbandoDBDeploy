
CREATE PROCEDURE [dbo].[Global_TypeDescription_GA]
AS
SET NOCOUNT ON

SELECT [Type]+CAST(IdLanguage AS VARCHAR(1)),[Description] 
FROM TypeDescription WITH(NOLOCK)