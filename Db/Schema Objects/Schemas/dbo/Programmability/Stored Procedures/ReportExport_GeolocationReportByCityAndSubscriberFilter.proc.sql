CREATE PROCEDURE [dbo].[ReportExport_GeolocationReportByCityAndSubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,  
@CountryCode varchar(2),  
@Latitude float,  
@Longitude float,
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
SubscriberClicks int,  
CountryName varchar(255),  
CityName varchar(50)
)  
DECLARE @t TABLE ( 
IdCampaign INT PRIMARY KEY ); 

INSERT INTO @t 
SELECT IdCampaign 
FROM GetTestABSet(@IdCampaign);

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
SUM(ISNULL(lt.Count,1)) SubscriberClicks, co.Name, lo.City 
FROM @t t
INNER JOIN dbo.CampaignDeliveriesOpenInfo c  WITH(NOLOCK)       
ON c.IdCampaign=t.IdCampaign 
INNER JOIN dbo.Subscriber S WITH(NOLOCK)   
ON c.IdSubscriber=s.IdSubscriber 
LEFT JOIN dbo.Link L WITH(NOLOCK) 
ON c.IdCampaign=L.IdCampaign 
LEFT JOIN dbo.LinkTracking lt WITH(NOLOCK)  
ON lt.IdLink=L.IdLink AND c.IdSubscriber=lt.IdSubscriber 
LEFT JOIN Location lo  WITH(NOLOCK)  
ON c.LocId=lo.LocId 
LEFT JOIN Country co   WITH(NOLOCK)  
ON co.Code=lo.Country 
WHERE c.IdDeliveryStatus=100
AND co.Code=@CountryCode
AND lo.Latitude=@Latitude AND lo.Longitude=@Longitude  
AND s.Email like @EmailNameFilter
AND ISNULL(s.FirstName,'') like @firstnameFilter
AND ISNULL(s.LastName, '') like @lastnameFilter
GROUP BY  S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
co.Name, lo.City 

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
 From Field F WITH(NOLOCK)      
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
      
 set @sql2='SELECT Email, FirstName, LastName, SubscriberClicks, CountryName, CityName  ' + replace(@columns,'[','t.[')      
   + ' FROM #RE_LTR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, SubscriberClicks, CountryName, CityName 
 FROM #RE_LTR g  
END      
GO