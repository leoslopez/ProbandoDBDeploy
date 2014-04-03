CREATE PROCEDURE [dbo].[ReportExport_AperturesClicksReportBySubscriberFilter] 
@IdCampaign      INT, 
@CampaignStatus  INT,
@EmailNameFilter VARCHAR(50),
@firstNameFilter NVARCHAR(50),
@lastNameFilter  NVARCHAR(50)
AS 
SET NOCOUNT ON

CREATE TABLE #RE_ACR ( 
IdSubscriber     BIGINT, 
email            VARCHAR(100), 
firstname        NVARCHAR(150), 
lastname         NVARCHAR(150), 
SubscriberClicks INT ) 

DECLARE @t TABLE ( 
IdCampaign INT PRIMARY KEY ); 

INSERT INTO @t 
SELECT IdCampaign 
FROM GetTestABSet(@IdCampaign) 

INSERT INTO #RE_ACR 
SELECT S.IdSubscriber, 
S.Email, 
S.FirstName, 
S.LastName, 
ISNULL(LT.SubscriberClicks, 0) as SubscriberClicks 
FROM @t t 
JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
on t.IdCampaign = cdoi.IdCampaign 
LEFT JOIN dbo.Subscriber S WITH(NOLOCK) 
ON S.IdSubscriber = cdoi.IdSubscriber 
LEFT JOIN (SELECT LT.IdSubscriber, SUM(LT.Count) as SubscriberClicks 
			FROM @t t 
			JOIN Link L WITH(NOLOCK) 
			on t.IdCampaign = L.IdCampaign 
			JOIN LinkTracking LT WITH(NOLOCK) 
			ON LT.IdLink = L.IdLink 
			GROUP BY LT.IdSubscriber) LT 
ON Lt.IdSubscriber = cdoi.IdSubscriber 
WHERE cdoi.IdDeliveryStatus = 100 
AND s.Email like @EmailNameFilter 
AND ISNULL(s.FirstName, '') like @firstnameFilter 
AND ISNULL(s.LastName, '') like @lastnameFilter 

    -- Custom Fields      
    declare @sql VARCHAR(max) 
    declare @sql2 VARCHAR(max) 
    declare @in VARCHAR(max) 
    declare @columns VARCHAR(max) 
    declare @IdField INT 
    declare @Name VARCHAR(100) 
    DECLARE cur CURSOR FOR 
      SELECT DISTINCT f.IdField, 
                      f.Name 
      FROM   Field f  WITH(NOLOCK)
             JOIN FieldXSubscriber FxS  WITH(NOLOCK)
               ON f.IdField = FxS.IdField 
             JOIN CampaignDeliveriesOpenInfo cdoi  WITH(NOLOCK)
               ON FxS.IdSubscriber = cdoi.IdSubscriber 
      WHERE  cdoi.IdCampaign IN (SELECT IdCampaign 
                                 FROM   GetTestABSet(@IdCampaign)) 
             AND cdoi.IdDeliveryStatus = 100 

    set @in='' 
    set @sql='SELECT IdSubscriber' 
    set @columns='' 

    OPEN cur 

    FETCH NEXT FROM cur INTO @IdField, @Name 

    IF ( @@FETCH_STATUS = 0 ) 
      BEGIN 
          set @columns=', [' + @Name + ']' 
          set @in=convert(VARCHAR, @IdField) 

          FETCH NEXT FROM cur INTO @IdField, @Name 

          WHILE @@FETCH_STATUS = 0 
            BEGIN 
                set @columns=@columns + ', [' + @Name + ']' 
                set @in=@in + ',' + convert(VARCHAR, @IdField) 

                FETCH NEXT FROM cur INTO @IdField, @Name 
            END 
      END -- IF       

    CLOSE cur 

    DEALLOCATE cur 

    IF @columns <> '' 
      BEGIN 
          set @sql=@sql + @columns + ' FROM (        Select IdSubscriber, Value, Name        From Field F  WITH(NOLOCK)       join FieldXSubscriber FxS WITH(NOLOCK)  on f.IdField=FxS.IdField  where f.IdField in (' + @in 
                   + ')        ) po        PIVOT        (        max(Value)         FOR Name IN          (' + substring(@columns, 3, 100000) 
                   + ')         ) AS PVT ' 
          set @sql2='SELECT Email, FirstName, LastName, SubscriberClicks' 
                    + replace(@columns, '[', 't.[') 
                    + ' FROM #RE_ACR g           LEFT JOIN (' + @sql 
                    + ')t           ON g.IdSubscriber=t.IdSubscriber' 

          --print(@sql2)     
          execute(@sql2) 
      END 
    ELSE 
      BEGIN 
          SELECT Email, 
                 FirstName, 
                 LastName, 
                 SubscriberClicks 
          FROM   #RE_ACR g 
      END      
GO
