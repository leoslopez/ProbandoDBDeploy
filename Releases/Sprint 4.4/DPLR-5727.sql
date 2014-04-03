-- =============================================
-- Script Template
-- =============================================
CREATE TABLE #SUB_CONTENT        
(        
   IdCampaign bigint,  PlainText nvarchar(max)      
) 

INSERT INTO #SUB_CONTENT        
SELECT C.IdCampaign,PlainText         
FROM dbo.Content C WITH(NOLOCK)        
WHERE PlainText like '%<!--%-->%' and IdCampaign in(select IdCampaign from Campaign where UTCCreationDate >= '2014-02-01')

DECLARE @IdCampaign int
DECLARE @PlainText nvarchar(max)
DECLARE @start INT, @end INT 

DECLARE cur CURSOR FOR           
SELECT C.IdCampaign, C.PlainText
FROM #SUB_CONTENT C
          
OPEN cur          
FETCH NEXT FROM cur           
INTO @IdCampaign, @PlainText
WHILE @@FETCH_STATUS = 0
BEGIN
   
SET @start = charindex('<!--',@PlainText)
SET @end = charindex('-->',@PlainText) 

  WHILE @start > 0 BEGIN 
     SELECT @PlainText = Stuff(@PlainText,@start,(@end-@start)+3,'') 
     SET @start = charindex('<!--',@PlainText)
     SET @end = charindex('-->',@PlainText) 
   END 

 UPDATE dbo.Content
    SET PlainText = @PlainText      
    WHERE IdCampaign = @IdCampaign
 FETCH NEXT FROM cur 
 INTO @IdCampaign, @PlainText
END 
CLOSE cur;
DEALLOCATE cur;

DROP TABLE #SUB_CONTENT
