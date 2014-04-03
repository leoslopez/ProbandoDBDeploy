/****** Object:  StoredProcedure [dbo].[Global_TypeDescription_G]    Script Date: 08/07/2013 11:33:41 ******/

CREATE PROC [dbo].[Global_TypeDescription_G] 
@enumName varchar(100), @languageID int
AS
SET NOCOUNT ON

SELECT [Description]
FROM TypeDescription WITH(NOLOCK)
WHERE [Type]=@enumName AND IdLanguage=@languageID 