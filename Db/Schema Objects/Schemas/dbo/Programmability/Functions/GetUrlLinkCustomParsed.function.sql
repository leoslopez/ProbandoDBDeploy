CREATE FUNCTION [dbo].[GetUrlLinkCustomParsed] (@IdCampaign INT, 
                                                @IdLink     INT) 
RETURNS VARCHAR(250) 
as 
  BEGIN 
      Declare @Url VARCHAR (250) 

      SELECT @Url = UrlLink 
      FROM   dbo.Link 
      WHERE  IdLink = @IdLink 

      select @Url = REPLACE(@url, '|*|' + convert(VARCHAR, f.IdField) + '*|*', 
                                  '[[[' + f.Name + ']]]') 
      FROM   dbo.ContentXField cxf 
             JOIN dbo.Field f 
               on cxf.IdField = f.IdField 
      WHERE  cxf.IdContent = @IdCampaign 

      RETURN @Url 
  END 
