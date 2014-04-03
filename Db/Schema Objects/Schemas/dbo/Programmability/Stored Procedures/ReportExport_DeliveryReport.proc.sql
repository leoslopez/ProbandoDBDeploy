
CREATE PROCEDURE [dbo].[ReportExport_DeliveryReport]
@IdCampaign INT,    
@CampaignStatus int    
AS    
SET NOCOUNT ON

CREATE TABLE #RE_DR    
(   IdSubscriber bigint,    
    email varchar(100),    
    firstname nvarchar(150),    
    lastname nvarchar(150),    
    MailDeliveryStatus varchar(30),    
	MailDeliveryStatusDetail varchar(150),    
    TotalApertures int,    
    [Date] datetime    
)     

DECLARE @t TABLE ( 
IdCampaign INT PRIMARY KEY ); 

INSERT INTO @t 
SELECT IdCampaign 
FROM GetTestABSet(@IdCampaign) 
       
INSERT INTO #RE_DR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName,
CASE cdoi.IdDeliveryStatus     
                WHEN 0 THEN 0    
                WHEN 1 THEN 1    
                WHEN 2 THEN 1    
                WHEN 3 THEN 1    
                WHEN 4 THEN 1    
                WHEN 5 THEN 1    
                WHEN 6 THEN 1    
                WHEN 7 THEN 1    
                WHEN 8 THEN 1    
                WHEN 100 THEN 2    
                WHEN 101 THEN 3    
                ELSE 3    
           END AS MailDeliveryStatus,    
           cdoi.IdDeliveryStatus AS MailDeliveryStatusDetailed,    
           ISNULL(cdoi.Count,0) TotalApertures,    
           cdoi.[Date]
FROM @t t
JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
ON t.IdCampaign=cdoi.IdCampaign 
JOIN dbo.Subscriber S WITH(NOLOCK)    
ON S.IdSubscriber = cdoi.IdSubscriber    

      
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
JOIN FieldXSubscriber FxS  WITH(NOLOCK) ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi  WITH(NOLOCK) ON FxS.IdSubscriber = cdoi.IdSubscriber
WHERE cdoi.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND cdoi.IdDeliveryStatus=100
      
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
      
 set @sql2='SELECT Email, FirstName, LastName, MailDeliveryStatus, MailDeliveryStatusDetail, TotalApertures, g.[Date] ' + replace(@columns,'[','t.[')      
   + ' FROM #RE_DR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, MailDeliveryStatus, MailDeliveryStatusDetail, TotalApertures, [Date]  
 FROM #RE_DR g  
END