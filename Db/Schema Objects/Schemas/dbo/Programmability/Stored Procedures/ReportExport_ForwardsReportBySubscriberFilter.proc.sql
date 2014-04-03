CREATE PROCEDURE [dbo].[ReportExport_ForwardsReportBySubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,  
@EmailNameFilter varchar(100),   
@FirstNameFilter nvarchar(100),   
@LastNameFilter nvarchar(100)
AS    
SET NOCOUNT ON

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname nvarchar(150),  
lastname nvarchar(150),  
Forwards int
)  

DECLARE @t TABLE ( 
IdCampaign INT PRIMARY KEY ); 

INSERT INTO @t 
SELECT IdCampaign 
FROM GetTestABSet(@IdCampaign)

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, ISNULL(COUNT(ff.ForwardID),0) Forwards
FROM @t t
INNER JOIN dbo.ForwardFriend ff WITH(NOLOCK)    
ON ff.IdCampaign=t.IdCampaign 
LEFT JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)    
ON ff.IdCampaign=cdoi.IdCampaign AND ff.IdSubscriber=cdoi.IdSubscriber
LEFT JOIN dbo.Subscriber S WITH(NOLOCK)    
ON S.IdSubscriber = cdoi.IdSubscriber 
WHERE cdoi.IdDeliveryStatus=100
AND s.Email like @EmailNameFilter
AND ISNULL(s.FirstName,'') like @firstnameFilter
AND ISNULL(s.LastName, '') like @lastnameFilter
GROUP BY S.IdSubscriber, S.Email, S.FirstName, S.LastName
-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name 
FROM @t t
INNER JOIN dbo.ContentXField CxF WITH(NOLOCK)
ON t.IdCampaign=CxF.IdContent 
INNER JOIN Field f WITH(NOLOCK) 
ON f.IdField = CxF.IdField
WHERE f.IdField NOT IN (319,320,321,322,323,324)
      
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
 where f.IsBasicField=0 AND f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, Forwards  ' + replace(@columns,'[','t.[')      
   + ' FROM #RE_LTR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
  --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, Forwards 
 FROM #RE_LTR g  
END