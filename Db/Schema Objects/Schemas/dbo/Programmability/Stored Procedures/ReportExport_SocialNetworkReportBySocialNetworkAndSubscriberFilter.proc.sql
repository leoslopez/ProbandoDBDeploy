
CREATE PROCEDURE [dbo].[ReportExport_SocialNetworkReportBySocialNetworkAndSubscriberFilter]
@IdCampaign int,  
@CampaignStatus int,  
@IdSocialNetwork int,  
@EmailNameFilter varchar(100),   
@FirstNameFilter nvarchar(100),   
@LastNameFilter nvarchar(100)  
AS  
CREATE TABLE #RE_ACR    
(    
IdSubscriber bigint,    
email varchar(100),    
firstname nvarchar(150),    
lastname nvarchar(150),    
Cant int    
)    
INSERT INTO #RE_ACR  
SELECT s.IdSubscriber, s.Email, s.FirstName, s.LastName, c.count  
FROM Subscriber s WITH(NOLOCK)  
join dbo.SocialNetworkShareTracking c WITH(NOLOCK)  
on s.IdSubscriber=c.IdSubscriber  
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND c.IdSocialNetwork=@IdSocialNetwork
AND s.Email like @EmailNameFilter
AND ISNULL(s.FirstName,'') like @firstnameFilter
AND ISNULL(s.LastName, '') like @lastnameFilter

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
 From Field F  WITH(NOLOCK)     
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
      
 set @sql2='SELECT Email, FirstName, LastName, Cant' + replace(@columns,'[','t.[')      
   + ' FROM #RE_ACR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, Cant 
 FROM #RE_ACR
END