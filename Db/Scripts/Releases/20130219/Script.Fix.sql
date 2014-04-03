-- http://jira.makingsense.com/browse/DPLR-3962
ALTER PROCEDURE [dbo].[Common_CampaignCredits_UP] @IdCampaign int, @NeedMovements int
AS 
BEGIN
  BEGIN TRY 
      BEGIN TRAN 

      DECLARE @enviosTotal INT 
      DECLARE @enviosCampaign INT 
      DECLARE @PartialBalance INT 
      DECLARE @cobrado INT 
      DECLARE @dif INT 
      DECLARE @idReplicated INT 
	  DECLARE @idTestAB INT
	  DECLARE @testABCategory INT

      SET @enviosTotal=0 
      SET @enviosCampaign=0 
      SET @cobrado=0 
      SET @PartialBalance=0 
      SET @idReplicated=0 
      SET @testABCategory=0 

		SELECT @idTestAB = ISNULL(Campaign.IdTestAB,0), @testABCategory = ISNULL(Campaign.TestABCategory,0) FROM Campaign WHERE Campaign.IdCampaign = @IdCampaign

		UPDATE Campaign WITH(ROWLOCK) 
		SET    UTCSentDate = getUTCdate() 
		WHERE  IDcampaign = @IdCampaign 

		select @enviosCampaign = ISNULL(COUNT(1), 0) 
		from   CampaignDeliveriesOpenInfo WITH(NOLOCK) 
		where  IdCampaign = @IdCampaign 

		SET @enviosTotal = @enviosCampaign

		IF( @idTestAB > 0)
			BEGIN
			  select @enviosTotal = ISNULL(COUNT(1), 0) 
			  from   CampaignDeliveriesOpenInfo WITH(NOLOCK)
			  where  IdCampaign IN (SELECT IdCampaign FROM Campaign WHERE IdTestAb = @idTestAB)
			END

      IF((@idTestAB = 0 OR (@idTestAB > 0 AND @testABCategory = 3)) AND  @enviosTotal > 0  AND @NeedMovements = 1) 
        BEGIN 
            --Actualizo los envios para la camapaña 
            update Campaign 
            set    AmountSentSubscribers = @enviosCampaign 
            WHERE  IdCampaign = @IdCampaign 

            select @PartialBalance = ISNULL(PartialBalance, 0) 
            from   dbo.[MovementsCredits] WITH(NOLOCK) 
            where  IdMovementCredit = (SELECT MAX(IdMovementCredit) 
                                       from   dbo.[MovementsCredits] m WITH( 
                                              NOLOCK ) 
                                              JOIN Campaign c 
                                                ON m.Iduser = c.IdUser 
                                       WHERE  c.IdCampaign = @IdCampaign) 

            select @cobrado = ISNULL(CreditsQty, 0) 
            from   dbo.[MovementsCredits] WITH(NOLOCK) 
            where  IdCampaign = @IdCampaign 

            SET @dif=@cobrado * (-1) - @enviosTotal

            IF( @dif <> 0 
                AND @dif <> @enviosTotal ) 
              BEGIN 
                  INSERT INTO MovementsCredits 
                              (IdUser, 
                               Date, 
                               CreditsQty, 
                               IdCampaign, 
                               PartialBalance, 
                               ConceptEnglish,
							   ConceptSpanish) 
                  SELECT c.IdUser, 
                         GETUTCDATE(), 
                         @dif, 
                         @IdCampaign, 
                         @PartialBalance + @dif, 
                         'Adjustment Sent Campaign: ' + c.name,
						 'Ajuste Envío Campaña: ' + c.name 
                  from   Campaign c 
                  WHERE  c.IdCampaign = @IdCampaign 
              END 
        END 

      --Actualizo si tiene campañas replicadas. 
      select @idReplicated = ISNULL(IdCampaign, 0) 
      from   Campaign WITH(NOLOCK) 
      where  IdParentCampaign = @IdCampaign 

      IF( @idReplicated > 0 ) 
        BEGIN 
            UPDATE Campaign 
            SET    [Status] = 3, 
                   [Active] = 1 
            WHERE  IdCampaign = @idReplicated 
        END 


      --Actualizo el estado de la campaña 
      UPDATE Campaign WITH(ROWLOCK) 
      SET    [Status] = 5 
      WHERE  IdCampaign = @IdCampaign 

      COMMIT TRAN 
  END TRY 

  BEGIN CATCH 
      ROLLBACK TRAN 
  END CATCH 
END
GO
-- http://jira.makingsense.com/browse/DPLR-4049
ALTER PROCEDURE [dbo].[ReportExport_AperturesClicksReport]        
@IdCampaign INT,        
@CampaignStatus int        
AS        
CREATE TABLE #RE_ACR        
(        
IdSubscriber bigint,        
email varchar(100),        
firstname varchar(150),        
lastname varchar(150),        
SubscriberClicks int        
)        
           
INSERT INTO #RE_ACR        
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, ISNULL(LT.SubscriberClicks, 0) as SubscriberClicks        
FROM dbo.Subscriber S WITH(NOLOCK)        
RIGHT JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)        
ON S.IdSubscriber = cdoi.IdSubscriber        
LEFT JOIN (
	SELECT LT.IdSubscriber, SUM(LT.Count) as SubscriberClicks FROM LinkTracking LT
	LEFT JOIN Link L ON LT.IdLink = L.IdLink
	WHERE L.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))
	GROUP BY LT.IdSubscriber 
) LT ON Lt.IdSubscriber = cdoi.IdSubscriber
WHERE cdoi.IdCampaign  IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND cdoi.IdDeliveryStatus=100   
          
-- Custom Fields         
declare @sql varchar(max)         
declare @sql2 varchar(max)         
declare @in varchar(max)          
declare @columns varchar(max)          
declare @IdField int          
declare @Name varchar(100)          
          
DECLARE cur CURSOR FOR           
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
WHERE cdoi.IdCampaign  IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND cdoi.IdDeliveryStatus=100
          
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
 From Field F          
 join FieldXSubscriber FxS    
 on f.IdField=FxS.IdField    
 where f.IdField in (' + @in + ')          
 ) po          
 PIVOT          
 (          
 max(Value)           
 FOR Name IN           
  (' + substring(@columns,3,100000) + ')          
  ) AS PVT '          
          
 set @sql2='SELECT Email, FirstName, LastName, SubscriberClicks' + replace(@columns,'[','t.[')          
   + ' FROM #RE_ACR g          
    LEFT JOIN (' + @sql + ')t          
    ON g.IdSubscriber=t.IdSubscriber'        
          
    --print(@sql2)        
 execute(@sql2)         
END          
ELSE          
BEGIN          
 SELECT Email, FirstName, LastName, SubscriberClicks    
 FROM #RE_ACR g      
END
GO

ALTER PROCEDURE [dbo].[ReportExport_AperturesClicksReportByDay]
@IdCampaign INT,    
@CampaignStatus int,    
@ApertureDay datetime     
AS    
CREATE TABLE #RE_ACR    
(    
IdSubscriber bigint,    
email varchar(100),    
firstname varchar(150),    
lastname varchar(150),    
SubscriberClicks int    
)    
       
INSERT INTO #RE_ACR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, ISNULL(LT.SubscriberClicks,0) as SubscriberClicks    
FROM dbo.Subscriber S WITH(NOLOCK)    
RIGHT JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)        
ON S.IdSubscriber = cdoi.IdSubscriber        
LEFT JOIN (
	SELECT LT.IdSubscriber, SUM(LT.Count) as SubscriberClicks FROM LinkTracking LT
	LEFT JOIN Link L ON LT.IdLink = L.IdLink
	WHERE L.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))
	GROUP BY LT.IdSubscriber 
) LT ON Lt.IdSubscriber = cdoi.IdSubscriber
WHERE cdoi.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND cdoi.IdDeliveryStatus=100   
AND CONVERT(varchar(10),@ApertureDay,101)=CONVERT(varchar(10),cdoi.Date,101)     
      
-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, SubscriberClicks' + replace(@columns,'[','t.[')      
   + ' FROM #RE_ACR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, SubscriberClicks
 FROM #RE_ACR g  
END      
GO

ALTER PROCEDURE [dbo].[ReportExport_AperturesClicksReportByDayAndSubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,    
@ApertureDay datetime,   
@EmailNameFilter varchar(50),   
@firstNameFilter varchar(50),   
@lastNameFilter varchar(50)      
AS    
CREATE TABLE #RE_ACR    
(    
IdSubscriber bigint,    
email varchar(100),    
firstname varchar(150),    
lastname varchar(150),    
SubscriberClicks int    
)    
       
INSERT INTO #RE_ACR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, ISNULL(LT.SubscriberClicks,0) as SubscriberClicks    
FROM dbo.Subscriber S WITH(NOLOCK)    
RIGHT JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)        
ON S.IdSubscriber = cdoi.IdSubscriber        
LEFT JOIN (
	SELECT LT.IdSubscriber, SUM(LT.Count) as SubscriberClicks FROM LinkTracking LT
	LEFT JOIN Link L ON LT.IdLink = L.IdLink
	WHERE L.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))
	GROUP BY LT.IdSubscriber 
) LT ON Lt.IdSubscriber = cdoi.IdSubscriber
WHERE cdoi.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND cdoi.IdDeliveryStatus=100   
AND CONVERT(varchar(10),@ApertureDay,101)=CONVERT(varchar(10),cdoi.Date,101) 
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, SubscriberClicks' + replace(@columns,'[','t.[')      
   + ' FROM #RE_ACR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, SubscriberClicks
 FROM #RE_ACR g  
END      
GO

ALTER PROCEDURE [dbo].[ReportExport_AperturesClicksReportBySubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,    
@EmailNameFilter varchar(50),   
@firstNameFilter varchar(50),   
@lastNameFilter varchar(50)      
AS    
CREATE TABLE #RE_ACR    
(    
IdSubscriber bigint,    
email varchar(100),    
firstname varchar(150),    
lastname varchar(150),    
SubscriberClicks int    
)    
       
INSERT INTO #RE_ACR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, ISNULL(LT.SubscriberClicks, 0) as SubscriberClicks        
FROM dbo.Subscriber S WITH(NOLOCK)        
RIGHT JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)        
ON S.IdSubscriber = cdoi.IdSubscriber        
LEFT JOIN (
	SELECT LT.IdSubscriber, SUM(LT.Count) as SubscriberClicks FROM LinkTracking LT
	LEFT JOIN Link L ON LT.IdLink = L.IdLink
	WHERE L.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))
	GROUP BY LT.IdSubscriber 
) LT ON Lt.IdSubscriber = cdoi.IdSubscriber
WHERE cdoi.IdCampaign  IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND cdoi.IdDeliveryStatus=100   
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, SubscriberClicks' + replace(@columns,'[','t.[')      
   + ' FROM #RE_ACR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, SubscriberClicks
 FROM #RE_ACR g  
END      
GO

ALTER PROCEDURE [dbo].[ReportExport_DeliveryReport]
@IdCampaign INT,    
@CampaignStatus int    
AS    
CREATE TABLE #RE_DR    
(   IdSubscriber bigint,    
    email varchar(100),    
    firstname varchar(150),    
    lastname varchar(150),    
    MailDeliveryStatus varchar(30),    
	MailDeliveryStatusDetail varchar(150),    
    TotalApertures int,    
    [Date] datetime    
)     
       
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
FROM dbo.Subscriber S WITH(NOLOCK)    
RIGHT JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)    
ON S.IdSubscriber = cdoi.IdSubscriber    
WHERE cdoi.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))    
      
-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
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
GO

ALTER PROCEDURE [dbo].[ReportExport_DeliveryReportByStatus]
@IdCampaign INT,    
@CampaignStatus int,      
@MailDeliveryStatusID int -- NotOpened = 0,Bounced = 1,Opened = 2,NotSent = 3          
AS    
DECLARE @IdDeliveryStatus int

CREATE TABLE #RE_DR    
(   IdSubscriber bigint,    
    email varchar(100),    
    firstname varchar(150),    
    lastname varchar(150),    
    MailDeliveryStatus varchar(30),    
	MailDeliveryStatusDetail varchar(150),    
    TotalApertures int,    
    [Date] datetime    
)   
IF (@MailDeliveryStatusID=1)
BEGIN
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
FROM dbo.Subscriber S WITH(NOLOCK)    
JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)    
ON S.IdSubscriber = cdoi.IdSubscriber    
WHERE cdoi.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND cdoi.IdDeliveryStatus BETWEEN 1 AND 8
END
ELSE
BEGIN
SELECT @IdDeliveryStatus=
CASE @MailDeliveryStatusID
WHEN 0 THEN 0
WHEN 2 THEN 100 END 
     
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
FROM dbo.Subscriber S WITH(NOLOCK)    
RIGHT JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)    
ON S.IdSubscriber = cdoi.IdSubscriber    
WHERE cdoi.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND cdoi.IdDeliveryStatus=@IdDeliveryStatus           
END  
-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
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
GO

ALTER PROCEDURE [dbo].[ReportExport_DeliveryReportByStatusAndSubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,      
@MailDeliveryStatusID int, -- NotOpened = 0,Bounced = 1,Opened = 2,NotSent = 3          
@EmailNameFilter varchar(100),     
@FirstNameFilter varchar(100),     
@LastNameFilter varchar(100)
AS    
DECLARE @IdDeliveryStatus int

CREATE TABLE #RE_DR    
(   IdSubscriber bigint,    
    email varchar(100),    
    firstname varchar(150),    
    lastname varchar(150),    
    MailDeliveryStatus varchar(30),    
	MailDeliveryStatusDetail varchar(150),    
    TotalApertures int,    
    [Date] datetime    
)   
IF (@MailDeliveryStatusID=1)
BEGIN
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
FROM dbo.Subscriber S WITH(NOLOCK)    
JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)    
ON S.IdSubscriber = cdoi.IdSubscriber    
WHERE cdoi.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND cdoi.IdDeliveryStatus BETWEEN 1 AND 8           
AND s.Email like @EmailNameFilter
AND ISNULL(s.FirstName,'') like @firstnameFilter
AND ISNULL(s.LastName, '') like @lastnameFilter
END
ELSE
BEGIN
SELECT @IdDeliveryStatus=
CASE @MailDeliveryStatusID
WHEN 0 THEN 0
WHEN 2 THEN 100 END 
     
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
FROM dbo.Subscriber S WITH(NOLOCK)    
JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)    
ON S.IdSubscriber = cdoi.IdSubscriber    
WHERE cdoi.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND cdoi.IdDeliveryStatus=@IdDeliveryStatus           
AND s.Email like @EmailNameFilter
AND ISNULL(s.FirstName,'') like @firstnameFilter
AND ISNULL(s.LastName, '') like @lastnameFilter
END  
-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
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
GO

ALTER PROCEDURE [dbo].[ReportExport_DeliveryReportBySubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,      
@EmailNameFilter varchar(100),     
@FirstNameFilter varchar(100),     
@LastNameFilter varchar(100)
AS    
DECLARE @IdDeliveryStatus int

CREATE TABLE #RE_DR    
(   IdSubscriber bigint,    
    email varchar(100),    
    firstname varchar(150),    
    lastname varchar(150),    
    MailDeliveryStatus varchar(30),    
	MailDeliveryStatusDetail varchar(150),    
    TotalApertures int,    
    [Date] datetime    
)   

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
FROM dbo.Subscriber S WITH(NOLOCK)    
JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)    
ON S.IdSubscriber = cdoi.IdSubscriber    
WHERE cdoi.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
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
GO

ALTER PROCEDURE [dbo].[ReportExport_DesuscriptionsReport]
@IdCampaign INT,    
@CampaignStatus int
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
Unsubdate datetime 
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, s.UTCUnsubDate
FROM dbo.Subscriber S WITH(NOLOCK)       
WHERE s.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))

-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, Unsubdate  ' + replace(@columns,'[','t.[')      
   + ' FROM #RE_LTR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, Unsubdate 
 FROM #RE_LTR g  
END
GO

ALTER PROCEDURE [dbo].[ReportExport_DesuscriptionsReportBySubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,  
@EmailNameFilter varchar(100),   
@FirstNameFilter varchar(100),   
@LastNameFilter varchar(100)
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
Unsubdate datetime 
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, s.UTCUnsubDate
FROM dbo.Subscriber S WITH(NOLOCK)       
WHERE s.IdCampaign  IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) 
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, Unsubdate  ' + replace(@columns,'[','t.[')      
   + ' FROM #RE_LTR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, Unsubdate 
 FROM #RE_LTR g  
END
GO

ALTER PROCEDURE [dbo].[ReportExport_ForwardsReport]
@IdCampaign INT,    
@CampaignStatus int
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
Forwards int
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, ISNULL(COUNT(ff.ForwardID),0) Forwards
FROM dbo.Subscriber S WITH(NOLOCK)    
RIGHT JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)    
ON S.IdSubscriber = cdoi.IdSubscriber    
RIGHT JOIN dbo.ForwardFriend ff
ON ff.IdCampaign=cdoi.IdCampaign AND ff.IdSubscriber=cdoi.IdSubscriber 
WHERE cdoi.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND cdoi.IdDeliveryStatus=100
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
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
GO

ALTER PROCEDURE [dbo].[ReportExport_ForwardsReportBySubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,  
@EmailNameFilter varchar(100),   
@FirstNameFilter varchar(100),   
@LastNameFilter varchar(100)
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
Forwards int
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, ISNULL(COUNT(ff.ForwardID),0) Forwards
FROM dbo.Subscriber S WITH(NOLOCK)    
RIGHT JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)    
ON S.IdSubscriber = cdoi.IdSubscriber    
RIGHT JOIN dbo.ForwardFriend ff
ON ff.IdCampaign=cdoi.IdCampaign AND ff.IdSubscriber=cdoi.IdSubscriber 
WHERE cdoi.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND cdoi.IdDeliveryStatus=100
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
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
      
  print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, Forwards 
 FROM #RE_LTR g  
END
GO

ALTER PROCEDURE [dbo].[ReportExport_GeolocationReport]
@IdCampaign INT,    
@CampaignStatus int
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
SubscriberClicks int,  
CountryName varchar(255),  
CityName varchar(50)
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
SUM(ISNULL(lt.Count,1)) SubscriberClicks, co.Name, lo.City 
FROM dbo.Subscriber S WITH(NOLOCK)       
JOIN dbo.CampaignDeliveriesOpenInfo c  WITH(NOLOCK)       
ON c.IdSubscriber=s.IdSubscriber 
LEFT JOIN dbo.Link L WITH(NOLOCK) 
ON c.IdCampaign=L.IdCampaign 
LEFT JOIN dbo.LinkTracking lt WITH(NOLOCK)  
ON lt.IdLink=L.IdLink AND c.IdSubscriber=lt.IdSubscriber 
LEFT JOIN Location lo  WITH(NOLOCK)  
ON c.LocId=lo.LocId 
LEFT JOIN Country co   WITH(NOLOCK)  
ON co.Code=lo.Country 
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND c.IdDeliveryStatus=100
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
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

ALTER PROCEDURE [dbo].[ReportExport_GeolocationReportByCity]
@IdCampaign INT,    
@CampaignStatus int,  
@CountryCode varchar(2),  
@Latitude float,  
@Longitude float    
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
SubscriberClicks int,  
CountryName varchar(255),  
CityName varchar(50)
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
SUM(ISNULL(lt.Count,1)) SubscriberClicks, co.Name, lo.City 
FROM dbo.Subscriber S WITH(NOLOCK)       
JOIN dbo.CampaignDeliveriesOpenInfo c  WITH(NOLOCK)       
ON c.IdSubscriber=s.IdSubscriber 
LEFT JOIN dbo.Link L WITH(NOLOCK) 
ON c.IdCampaign=L.IdCampaign 
LEFT JOIN dbo.LinkTracking lt WITH(NOLOCK)  
ON lt.IdLink=L.IdLink AND c.IdSubscriber=lt.IdSubscriber 
LEFT JOIN Location lo  WITH(NOLOCK)  
ON c.LocId=lo.LocId 
LEFT JOIN Country co   WITH(NOLOCK)  
ON co.Code=lo.Country 
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND c.IdDeliveryStatus=100
AND co.Code=@CountryCode
AND lo.Latitude=@Latitude AND lo.Longitude=@Longitude  
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
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

ALTER PROCEDURE [dbo].[ReportExport_GeolocationReportByCityAndSubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,  
@CountryCode varchar(2),  
@Latitude float,  
@Longitude float,
@EmailNameFilter varchar(100),   
@FirstNameFilter varchar(100),   
@LastNameFilter varchar(100)   
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
SubscriberClicks int,  
CountryName varchar(255),  
CityName varchar(50)
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
SUM(ISNULL(lt.Count,1)) SubscriberClicks, co.Name, lo.City 
FROM dbo.Subscriber S WITH(NOLOCK)       
JOIN dbo.CampaignDeliveriesOpenInfo c  WITH(NOLOCK)       
ON c.IdSubscriber=s.IdSubscriber 
LEFT JOIN dbo.Link L WITH(NOLOCK) 
ON c.IdCampaign=L.IdCampaign 
LEFT JOIN dbo.LinkTracking lt WITH(NOLOCK)  
ON lt.IdLink=lt.IdLink AND c.IdSubscriber=lt.IdSubscriber 
LEFT JOIN Location lo  WITH(NOLOCK)  
ON c.LocId=lo.LocId 
LEFT JOIN Country co   WITH(NOLOCK)  
ON co.Code=lo.Country 
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND c.IdDeliveryStatus=100
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
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

ALTER PROCEDURE [dbo].[ReportExport_GeolocationReportByCountry]
@IdCampaign INT,    
@CampaignStatus int,  
@CountryCode varchar(2)  
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
SubscriberClicks int,  
CountryName varchar(255),  
CityName varchar(50)
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
SUM(ISNULL(lt.Count,1)) SubscriberClicks, co.Name, lo.City 
FROM dbo.Subscriber S WITH(NOLOCK)       
JOIN dbo.CampaignDeliveriesOpenInfo c  WITH(NOLOCK)       
ON c.IdSubscriber=s.IdSubscriber 
LEFT JOIN dbo.Link L WITH(NOLOCK) 
ON c.IdCampaign=L.IdCampaign 
LEFT JOIN dbo.LinkTracking lt WITH(NOLOCK)  
ON lt.IdLink=L.IdLink AND c.IdSubscriber=lt.IdSubscriber 
LEFT JOIN Location lo  WITH(NOLOCK)  
ON c.LocId=lo.LocId 
LEFT JOIN Country co   WITH(NOLOCK)  
ON co.Code=lo.Country 
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND c.IdDeliveryStatus=100
AND co.Code=@CountryCode
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
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

ALTER PROCEDURE [dbo].[ReportExport_GeolocationReportByCountryAndSubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,  
@CountryCode varchar(2),  
@EmailNameFilter varchar(100),   
@FirstNameFilter varchar(100),   
@LastNameFilter varchar(100)    
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
SubscriberClicks int,  
CountryName varchar(255),  
CityName varchar(50)
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
SUM(ISNULL(lt.Count,1)) SubscriberClicks, co.Name, lo.City 
FROM dbo.Subscriber S WITH(NOLOCK)       
JOIN dbo.CampaignDeliveriesOpenInfo c  WITH(NOLOCK)       
ON c.IdSubscriber=s.IdSubscriber 
LEFT JOIN dbo.Link L WITH(NOLOCK) 
ON c.IdCampaign=L.IdCampaign 
LEFT JOIN dbo.LinkTracking lt WITH(NOLOCK)  
ON lt.IdLink=L.IdLink AND c.IdSubscriber=lt.IdSubscriber 
LEFT JOIN Location lo  WITH(NOLOCK)  
ON c.LocId=lo.LocId 
LEFT JOIN Country co   WITH(NOLOCK)  
ON co.Code=lo.Country 
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND c.IdDeliveryStatus=100
AND co.Code=@CountryCode
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
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

ALTER PROCEDURE [dbo].[ReportExport_GeolocationReportBySubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,  
@EmailNameFilter varchar(100),   
@FirstNameFilter varchar(100),   
@LastNameFilter varchar(100)
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
SubscriberClicks int,  
CountryName varchar(255),  
CityName varchar(50)
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
SUM(ISNULL(lt.Count,1)) SubscriberClicks, co.Name, lo.City 
FROM dbo.Subscriber S WITH(NOLOCK)       
JOIN dbo.CampaignDeliveriesOpenInfo c  WITH(NOLOCK)       
ON c.IdSubscriber=s.IdSubscriber 
LEFT JOIN dbo.Link L WITH(NOLOCK) 
ON c.IdCampaign=L.IdCampaign 
LEFT JOIN dbo.LinkTracking lt WITH(NOLOCK)  
ON lt.IdLink=L.IdLink AND c.IdSubscriber=lt.IdSubscriber 
LEFT JOIN Location lo  WITH(NOLOCK)  
ON c.LocId=lo.LocId 
LEFT JOIN Country co   WITH(NOLOCK)  
ON co.Code=lo.Country 
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND c.IdDeliveryStatus=100
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
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

ALTER PROCEDURE [dbo].[ReportExport_LinkTrackingReport]
@IdCampaign INT,    
@CampaignStatus int
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
SubscriberClicks int,  
LinkURL varchar(800)  
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, SUM(ISNULL(lt.Count,1)) SubscriberClicks, L.UrlLink FROM LinkTracking LT
INNER JOIN Link L ON L.IdLink = LT.IdLink
LEFT JOIN Subscriber S ON LT.IdSubscriber = S.IdSubscriber
WHERE L.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))
GROUP BY S.IdSubscriber, S.Email, S.FirstName, S.LastName, L.UrlLink

-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, SubscriberClicks, LinkURL  ' + replace(@columns,'[','t.[')      
   + ' FROM #RE_LTR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, SubscriberClicks, LinkURL 
 FROM #RE_LTR g  
END
GO

ALTER PROCEDURE [dbo].[ReportExport_LinkTrackingReportByLink]
@IdCampaign INT,    
@CampaignStatus int,  
@IdLink int  
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
SubscriberClicks int,  
LinkURL varchar(800)  
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, SUM(ISNULL(lt.Count,1)) SubscriberClicks, L.UrlLink FROM LinkTracking LT
INNER JOIN Link L ON L.IdLink = LT.IdLink
LEFT JOIN Subscriber S ON LT.IdSubscriber = S.IdSubscriber
WHERE L.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))
AND L.IdLink = @IdLink
GROUP BY S.IdSubscriber, S.Email, S.FirstName, S.LastName, L.UrlLink

-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, SubscriberClicks, LinkURL  ' + replace(@columns,'[','t.[')      
   + ' FROM #RE_LTR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, SubscriberClicks, LinkURL 
 FROM #RE_LTR g  
END
GO

ALTER PROCEDURE [dbo].[ReportExport_LinkTrackingReportByLinkAndSubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,  
@IdLink int,   
@EmailNameFilter varchar(100),   
@FirstNameFilter varchar(100),   
@LastNameFilter varchar(100)
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
SubscriberClicks int,  
LinkURL varchar(800)  
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, SUM(ISNULL(lt.Count,1)) SubscriberClicks, L.UrlLink FROM LinkTracking LT
INNER JOIN Link L ON L.IdLink = LT.IdLink
LEFT JOIN Subscriber S ON LT.IdSubscriber = S.IdSubscriber
WHERE L.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))
AND L.IdLink = @IdLink
AND s.Email like @EmailNameFilter
AND ISNULL(s.FirstName,'') like @firstnameFilter
AND ISNULL(s.LastName, '') like @lastnameFilter
GROUP BY S.IdSubscriber, S.Email, S.FirstName, S.LastName, L.UrlLink

-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, SubscriberClicks, LinkURL  ' + replace(@columns,'[','t.[')      
   + ' FROM #RE_LTR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, SubscriberClicks, LinkURL 
 FROM #RE_LTR g  
END
GO

ALTER PROCEDURE [dbo].[ReportExport_LinkTrackingReportBySubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,  
@EmailNameFilter varchar(100),   
@FirstNameFilter varchar(100),   
@LastNameFilter varchar(100)
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
SubscriberClicks int,  
LinkURL varchar(800)  
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, SUM(ISNULL(lt.Count,1)) SubscriberClicks, L.UrlLink FROM LinkTracking LT
INNER JOIN Link L ON L.IdLink = LT.IdLink
LEFT JOIN Subscriber S ON LT.IdSubscriber = S.IdSubscriber
WHERE L.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))
AND S.Email like @EmailNameFilter
AND ISNULL(S.FirstName,'') like @firstnameFilter
AND ISNULL(S.LastName, '') like @lastnameFilter
GROUP BY S.IdSubscriber, S.Email, S.FirstName, S.LastName, L.UrlLink
-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, SubscriberClicks, LinkURL  ' + replace(@columns,'[','t.[')      
   + ' FROM #RE_LTR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, SubscriberClicks, LinkURL 
 FROM #RE_LTR g  
END
GO

ALTER PROCEDURE [dbo].[ReportExport_SocialNetworkReportBySocialNetwork]
@IdCampaign int,  
@CampaignStatus int,  
@IdSocialNetwork int  
AS  
CREATE TABLE #RE_ACR    
(    
IdSubscriber bigint,    
email varchar(100),    
firstname varchar(150),    
lastname varchar(150),    
Cant int    
)    
INSERT INTO #RE_ACR  
SELECT s.IdSubscriber, s.Email, s.FirstName, s.LastName, c.count  
FROM Subscriber s WITH(NOLOCK)  
join dbo.SocialNetworkShareTracking c WITH(NOLOCK)  
on s.IdSubscriber=c.IdSubscriber  
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND c.IdSocialNetwork=@IdSocialNetwork

-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
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
GO

ALTER PROCEDURE [dbo].[ReportExport_SocialNetworkReportBySocialNetworkAndSubscriberFilter]
@IdCampaign int,  
@CampaignStatus int,  
@IdSocialNetwork int,  
@EmailNameFilter varchar(100),   
@FirstNameFilter varchar(100),   
@LastNameFilter varchar(100)  
AS  
CREATE TABLE #RE_ACR    
(    
IdSubscriber bigint,    
email varchar(100),    
firstname varchar(150),    
lastname varchar(150),    
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
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
GO

ALTER PROCEDURE [dbo].[ReportExport_SocialNetworkReportBySocialNetworkList]
@IdCampaign INT,    
@CampaignStatus int,  
@socialNetworkList varchar(300) /*Lista Id Social Networks por Coma*/     
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
cant int
)  
DECLARE @sql0 varchar(max)  
  
SET @sql0='INSERT INTO #RE_LTR  
SELECT s.IdSubscriber, s.Email, s.FirstName, s.LastName, COUNT(c.IdSocialNetwork) cant  
FROM Subscriber s  
JOIN dbo.SocialNetworkShareTracking c  
ON s.IdSubscriber=c.IdSubscriber   
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet('+convert(varchar,@IdCampaign)+')) AND c.IdSocialNetwork in ('+@socialNetworkList+')  
GROUP BY s.IdSubscriber, s.Email, s.FirstName, s.LastName'  
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
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
GO

ALTER PROCEDURE [dbo].[ReportExport_SocialNetworkReportBySocialNetworkListAndSubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,  
@socialNetworkList varchar(300), /*Lista Id Social Networks por Coma*/     
@EmailNameFilter varchar(100),   
@FirstNameFilter varchar(100),   
@LastNameFilter varchar(100)
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
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
GO

ALTER PROCEDURE [dbo].[ReportExport_SocialNetworksReport]
@IdCampaign INT,    
@CampaignStatus int
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
cant int
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
ISNULL(SUM(c.Count),0) cant
FROM dbo.Subscriber S WITH(NOLOCK)       
JOIN dbo.SocialNetworkShareTracking c  WITH(NOLOCK)       
ON c.IdSubscriber=s.IdSubscriber 
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))
GROUP BY  S.IdSubscriber, S.Email, S.FirstName, S.LastName

-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, cant  ' + replace(@columns,'[','t.[')      
   + ' FROM #RE_LTR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, cant
 FROM #RE_LTR g  
END
GO

ALTER PROCEDURE [dbo].[ReportExport_SocialNetworksReportBySubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,  
@EmailNameFilter varchar(100),   
@FirstNameFilter varchar(100),   
@LastNameFilter varchar(100)
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
cant int
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
ISNULL(SUM(c.Count),0) cant
FROM dbo.Subscriber S WITH(NOLOCK)       
JOIN dbo.SocialNetworkShareTracking c  WITH(NOLOCK)       
ON c.IdSubscriber=s.IdSubscriber 
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))
AND s.Email like @EmailNameFilter
AND ISNULL(s.FirstName,'') like @firstnameFilter
AND ISNULL(s.LastName, '') like @lastnameFilter
GROUP BY  S.IdSubscriber, S.Email, S.FirstName, S.LastName

-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, cant  ' + replace(@columns,'[','t.[')      
   + ' FROM #RE_LTR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, cant
 FROM #RE_LTR g  
END      
GO

ALTER PROCEDURE [dbo].[ReportExport_UserMailAgentsReport]
@IdCampaign INT,    
@CampaignStatus int
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
UserMailAgent int,  
UserAgentTypeID int,  
[Platform] int,  
OpenCount int
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
c.IdUserMailAgent, u.IdUserMailAgentType, c.IdPlatform, c.Count 
FROM dbo.Subscriber S WITH(NOLOCK)       
JOIN dbo.CampaignDeliveriesOpenInfo c  WITH(NOLOCK)   
ON S.IdSubscriber = c.IdSubscriber        
LEFT JOIN dbo.UserMailAgents u WITH(NOLOCK)       
ON c.IdUserMailAgent=U.IdUserMailAgent     
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))

-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F          
 join FieldXSubscriber FxS    
 on f.IdField=FxS.IdField    
 where f.IdField in (' + @in + ')          
 ) po          
 PIVOT          
 (          
 max(Value)           
 FOR Name IN           
  (' + substring(@columns,3,100000) + ')          
  ) AS PVT '          
          
 set @sql2='SELECT Email, FirstName, LastName, [Platform], UserAgentTypeID,  OpenCount  ' + replace(@columns,'[','t.[')          
   + ' FROM #RE_LTR g          
    LEFT JOIN (' + @sql + ')t          
    ON g.IdSubscriber=t.IdSubscriber'        
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, [Platform], UserAgentTypeID,  OpenCount
 FROM #RE_LTR g  
END
GO

ALTER PROCEDURE [dbo].[ReportExport_UserMailAgentsReportBySubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,  
@EmailNameFilter varchar(100),   
@FirstNameFilter varchar(100),   
@LastNameFilter varchar(100)
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname varchar(150),  
lastname varchar(150),  
UserMailAgent int,  
UserAgentTypeID int,  
[Platform] int,  
OpenCount int
)  

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
c.IdUserMailAgent, u.IdUserMailAgentType, c.IdPlatform, c.Count 
FROM dbo.Subscriber S WITH(NOLOCK)       
JOIN dbo.CampaignDeliveriesOpenInfo c  WITH(NOLOCK)       
ON c.IdSubscriber=s.IdSubscriber 
JOIN dbo.UserMailAgents u WITH(NOLOCK)       
ON u.IdUserMailAgent=c.IdUserMailAgent 
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, [Platform], UserAgentTypeID,  OpenCount  ' + replace(@columns,'[','t.[')      
   + ' FROM #RE_LTR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, [Platform], UserAgentTypeID,  OpenCount
 FROM #RE_LTR g  
END
GO

ALTER PROCEDURE [dbo].[ReportExport_UserMailAgentsReportByUserMailAgent]
@IdCampaign int,  
@CampaignStatus int,  
@IdUserMailAgentType int  
AS  
CREATE TABLE #RE_ACR    
(    
IdSubscriber bigint,    
email varchar(100),    
firstname varchar(150),    
lastname varchar(150),    
IdUserMailAgent int,  
IdUserAgentType int,  
IdPlatform int,  
OpenCount int    
)    
INSERT INTO #RE_ACR  
SELECT s.IdSubscriber, s.Email, s.FirstName, s.LastName, 
c.IdUserMailAgent, u.IdUserMailAgentType,   
c.IdPlatform, c.Count    
FROM Subscriber s WITH(NOLOCK)  
JOIN CampaignDeliveriesOpenInfo c WITH(NOLOCK)  
ON s.IdSubscriber=c.IdSubscriber   
JOIN dbo.UserMailAgents u  WITH(NOLOCK)  
on c.IdUserMailAgent=u.IdUserMailAgent   
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND u.IdUserMailAgentType=@IdUserMailAgentType   
-- Custom Fields     
declare @sql varchar(max)     
declare @sql2 varchar(max)     
declare @in varchar(max)      
declare @columns varchar(max)      
declare @IdField int      
declare @Name varchar(100)      
      
DECLARE cur CURSOR FOR       
SELECT DISTINCT f.IdField, f.Name
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, IdPlatform, IdUserAgentType,  OpenCount' + replace(@columns,'[','t.[')      
   + ' FROM #RE_ACR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, IdPlatform, IdUserAgentType,  OpenCount  
 FROM #RE_ACR g  
END
GO

ALTER PROCEDURE [dbo].[ReportExport_UserMailAgentsReportByUserMailAgentAndSubscriberFilter]
@IdCampaign int,  
@CampaignStatus int,  
@IdUserMailAgentType int,
@EmailNameFilter varchar(100),   
@FirstNameFilter varchar(100),   
@LastNameFilter varchar(100)  
AS  
CREATE TABLE #RE_ACR    
(    
IdSubscriber bigint,    
email varchar(100),    
firstname varchar(150),    
lastname varchar(150),    
IdUserMailAgent int,  
IdUserAgentType int,  
IdPlatform int,  
OpenCount int    
)    
INSERT INTO #RE_ACR  
SELECT s.IdSubscriber, s.Email, s.FirstName, s.LastName, 
c.IdUserMailAgent, u.IdUserMailAgentType,   
c.IdPlatform, c.Count    
FROM Subscriber s WITH(NOLOCK)  
JOIN CampaignDeliveriesOpenInfo c WITH(NOLOCK)  
ON s.IdSubscriber=c.IdSubscriber   
JOIN dbo.UserMailAgents u  WITH(NOLOCK)  
on c.IdUserMailAgent=u.IdUserMailAgent   
WHERE c.IdCampaign IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign)) AND u.IdUserMailAgentType=@IdUserMailAgentType   
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
FROM Field f
JOIN FieldXSubscriber FxS ON f.IdField=FxS.IdField
JOIN CampaignDeliveriesOpenInfo cdoi ON FxS.IdSubscriber = cdoi.IdSubscriber
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
 From Field F      
 join FieldXSubscriber FxS
 on f.IdField=FxS.IdField
 where f.IdField in (' + @in + ')      
 ) po      
 PIVOT      
 (      
 max(Value)       
 FOR Name IN       
  (' + substring(@columns,3,100000) + ')      
  ) AS PVT '      
      
 set @sql2='SELECT Email, FirstName, LastName, IdPlatform, IdUserAgentType,  OpenCount' + replace(@columns,'[','t.[')      
   + ' FROM #RE_ACR g      
    LEFT JOIN (' + @sql + ')t      
    ON g.IdSubscriber=t.IdSubscriber'    
      
    --print(@sql2)    
 execute(@sql2)     
END      
ELSE      
BEGIN      
 SELECT Email, FirstName, LastName, IdPlatform, IdUserAgentType,  OpenCount  
 FROM #RE_ACR g  
END
GO
