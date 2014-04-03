CREATE FUNCTION [dbo].[FormatDateByLanguage]
(
 @language INT,
 @date datetime
)
RETURNS varchar(MAX)
AS
BEGIN

   IF(@date IS NULL OR @date = '' OR ISDATE(@date) != 1) return null
   
   if (@language = 1)--Spanish
	 return Convert(varchar, @date,103)

   if (@language = 2)--English
	 return Convert(varchar, @date,101)

 return Convert(varchar, @date,101)
END