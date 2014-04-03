
CREATE PROCEDURE [dbo].[ReportExport_SocialNetworkReportBySocialNetworkListAndSubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,  
@socialNetworkList varchar(300), /*Lista Id Social Networks por Coma*/     
@EmailNameFilter varchar(100),   
@FirstNameFilter nvarchar(100),   
@LastNameFilter nvarchar(100)
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname nvarchar(150),  
lastname nvarchar(150),  
cant int
)  
DECLARE @sql0 varchar(max)  
  
SET @sql0='INSERT INTO #RE_LTR  
SELECT s.IdSubscriber, s.Email, s.FirstName, s.LastName, COUNT(c.IdSocialNetwork) cant  
FROM Subscriber s  
JOIN dbo.SocialNetworkShareTracking c  
ON s.IdSubscriber=c.IdSubscriber   
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet('+convert(varchar,@IdCampaign)+')) AND c.IdSocialNetwork in ('+@socialNetworkList+')  
AND s.Email like '+CHAR(39)+ @EmailNameFilter  +CHAR(39)+ '
AND ISNULL(s.FirstName,'+CHAR(39)+CHAR(39)+') like '+CHAR(39)+ @FirstNameFilter +CHAR(39)+ 
' AND ISNULL(s.LastName, '+CHAR(39)+CHAR(39)+') like ' +CHAR(39)+ @LastNameFilter +CHAR(39)+ 
' GROUP BY s.IdSubscriber, s.Email, s.FirstName, s.LastName'  
print (@sql0)
EXECUTE (@sql0)

-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f WITH(NOLOCK)
JOIN FieldXSubscriber FxS WITH(NOLOCK) ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) ON FxS.IdSubscriber = cdoi.IdSubscriber
WHERE cdoi.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))    
      
set @in=''      
set @sql='SELECT IdSubscriber'      
set @columns=''      
      
OPEN cur      
FETCH NEXT FROM cur       
INTO @IdField, @Name      
IF (@@FETCH_STATUS = 0)      
BEGIN      
 set @columns=', [' + @Name + ']'      
 set @in=convert(varchar,@IdField)      
 FETCH NEXT FROM cur       
 INTO @IdField, @Name      
      
 WHILE @@FETCH_STATUS = 0      
 BEGIN      
  set @columns=@columns + ', [' + @Name + ']'      
  set @in=@in + ','  + convert(varchar,@IdField)      
      
 FETCH NEXT FROM cur       
 INTO @IdField, @Name      
 END      
      
END -- IF      
CLOSE cur      
DEALLOCATE cur      
      
IF @columns <> ''      
BEGIN        
 set @sql=@sql + @columns + ' FROM (      
 Select IdSubscriber, Value, Name      
 From Field F WITH(NOLOCK)       
 join FieldXSubscriber FxS WITH(NOLOCK)
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, Cant  ' + replace(@columns,'[','t.[')      
   + ' FROM #RE_LTR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, Cant 
 FROM #RE_LTR g  
END