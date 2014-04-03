
CREATE PROCEDURE [dbo].[Global_Settings_GX]
@name varchar(150)
AS
SET NOCOUNT ON

SELECT Name, Setting
FROM Setting WITH(NOLOCK)
WHERE Name = @name