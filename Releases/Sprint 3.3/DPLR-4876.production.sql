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
GO

ALTER PROCEDURE [dbo].[ReportExport_LinkTrackingReport] @IdCampaign     INT, 
                                                        @CampaignStatus int 
AS 
    CREATE TABLE #RE_LTR 
      ( 
         IdSubscriber     bigint, 
         email            varchar(100), 
         firstname        varchar(150), 
         lastname         varchar(150), 
         SubscriberClicks int, 
         LinkURL          varchar(800) 
      ) 

    INSERT INTO #RE_LTR 
    SELECT S.IdSubscriber, 
           S.Email, 
           S.FirstName, 
           S.LastName, 
           SUM(ISNULL(lt.Count, 1)) 
           SubscriberClicks, 
           [dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) UrlLink 
    FROM   LinkTracking LT 
           INNER JOIN Link L WITH(NOLOCK) 
                   ON L.IdLink = LT.IdLink 
           LEFT JOIN Subscriber S WITH(NOLOCK) 
                  ON LT.IdSubscriber = S.IdSubscriber 
    WHERE  L.IdCampaign IN (SELECT IdCampaign 
                            FROM   GetTestABSet(@IdCampaign)) 
    GROUP  BY S.IdSubscriber, 
              S.Email, 
              S.FirstName, 
              S.LastName, 
              [dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) 

    -- Custom Fields          
    declare @sql varchar(max) 
    declare @sql2 varchar(max) 
    declare @in varchar(max) 
    declare @columns varchar(max) 
    declare @IdField int 
    declare @Name varchar(100) 
    DECLARE cur CURSOR FOR 
      SELECT DISTINCT f.IdField, 
                      f.Name 
      FROM   Field f WITH(NOLOCK) 
             JOIN Campaign c WITH(NOLOCK) 
               on f.IdUser = c.IdUser 
      WHERE  c.IdCampaign = @IdCampaign 
             and f.Active = 1 

    set @in='' 
    set @sql='SELECT IdSubscriber' 
    set @columns='' 

    OPEN cur 

    FETCH NEXT FROM cur INTO @IdField, @Name 

    IF ( @@FETCH_STATUS = 0 ) 
      BEGIN 
          set @columns=', [' + @Name + ']' 
          set @in=convert(varchar, @IdField) 

          FETCH NEXT FROM cur INTO @IdField, @Name 

          WHILE @@FETCH_STATUS = 0 
            BEGIN 
                set @columns=@columns + ', [' + @Name + ']' 
                set @in=@in + ',' + convert(varchar, @IdField) 

                FETCH NEXT FROM cur INTO @IdField, @Name 
            END 
      END -- IF           

    CLOSE cur 

    DEALLOCATE cur 

    IF @columns <> '' 
      BEGIN 
          set @sql=@sql + @columns + ' FROM (Select IdSubscriber, Value, Name From Field F   WITH(NOLOCK) join FieldXSubscriber FxS  WITH(NOLOCK)     on f.IdField=FxS.IdField      where f.IdField in (' + @in 
                   + ') ) po PIVOT ( max(Value) FOR Name IN (' + substring(@columns, 3, 100000) 
                   + ')) AS PVT ' 
          set @sql2= 
          'SELECT Email, FirstName, LastName, SubscriberClicks, LinkURL  ' 
          + replace(@columns, '[', 't.[') 
          + ' FROM #RE_LTR g LEFT JOIN (' + @sql 
          + ')t ON g.IdSubscriber=t.IdSubscriber' 

          print( @sql2 ) 

          execute(@sql2) 
      END 
    ELSE 
      BEGIN 
          SELECT Email, 
                 FirstName, 
                 LastName, 
                 SubscriberClicks, 
                 LinkURL 
          FROM   #RE_LTR g 
      END 
GO

ALTER PROCEDURE [dbo].[ReportExport_LinkTrackingReportByLink] @IdCampaign 
INT, 
                                                              @CampaignStatus 
int, 
                                                              @IdLink 
int 
AS 
    CREATE TABLE #RE_LTR 
      ( 
         IdSubscriber     bigint, 
         email            varchar(100), 
         firstname        varchar(150), 
         lastname         varchar(150), 
         SubscriberClicks int, 
         LinkURL          varchar(800) 
      ) 

    INSERT INTO #RE_LTR 
    SELECT S.IdSubscriber, 
           S.Email, 
           S.FirstName, 
           S.LastName, 
           SUM(ISNULL(lt.Count, 1)) 
           SubscriberClicks, 
           [dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) UrlLink 
    FROM   LinkTracking LT 
           INNER JOIN Link L WITH(NOLOCK) 
                   ON L.IdLink = LT.IdLink 
           LEFT JOIN Subscriber S WITH(NOLOCK) 
                  ON LT.IdSubscriber = S.IdSubscriber 
    WHERE  L.IdCampaign IN (SELECT IdCampaign 
                            FROM   GetTestABSet(@IdCampaign)) 
           AND L.IdLink = @IdLink 
    GROUP  BY S.IdSubscriber, 
              S.Email, 
              S.FirstName, 
              S.LastName, 
              [dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) 

    -- Custom Fields      
    declare @sql varchar(max) 
    declare @sql2 varchar(max) 
    declare @in varchar(max) 
    declare @columns varchar(max) 
    declare @IdField int 
    declare @Name varchar(100) 
    DECLARE cur CURSOR FOR 
      SELECT DISTINCT f.IdField, 
                      f.Name 
      FROM   Field f WITH(NOLOCK) 
             JOIN FieldXSubscriber FxS WITH(NOLOCK) 
               ON f.IdField = FxS.IdField 
             JOIN CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
               ON FxS.IdSubscriber = cdoi.IdSubscriber 
      WHERE  cdoi.IdCampaign IN (SELECT IdCampaign 
                                 FROM   GetTestABSet(@IdCampaign)) 

    set @in='' 
    set @sql='SELECT IdSubscriber' 
    set @columns='' 

    OPEN cur 

    FETCH NEXT FROM cur INTO @IdField, @Name 

    IF ( @@FETCH_STATUS = 0 ) 
      BEGIN 
          set @columns=', [' + @Name + ']' 
          set @in=convert(varchar, @IdField) 

          FETCH NEXT FROM cur INTO @IdField, @Name 

          WHILE @@FETCH_STATUS = 0 
            BEGIN 
                set @columns=@columns + ', [' + @Name + ']' 
                set @in=@in + ',' + convert(varchar, @IdField) 

                FETCH NEXT FROM cur INTO @IdField, @Name 
            END 
      END -- IF       

    CLOSE cur 

    DEALLOCATE cur 

    IF @columns <> '' 
      BEGIN 
          set @sql=@sql + @columns + ' FROM (Select IdSubscriber, Value, Name From Field F  WITH(NOLOCK) join FieldXSubscriber FxS WITH(NOLOCK)  on f.IdField=FxS.IdField  where f.IdField in (' + @in 
                   + ')) po PIVOT (max(Value) FOR Name IN (' + substring(@columns, 3, 100000) 
                   + ')) AS PVT ' 
          set @sql2= 
          'SELECT Email, FirstName, LastName, SubscriberClicks, LinkURL  ' 
          + replace(@columns, '[', 't.[') 
          + ' FROM #RE_LTR g LEFT JOIN (' + @sql 
          + ')t ON g.IdSubscriber=t.IdSubscriber' 

          --print(@sql2)     
          execute(@sql2) 
      END 
    ELSE 
      BEGIN 
          SELECT Email, 
                 FirstName, 
                 LastName, 
                 SubscriberClicks, 
                 LinkURL 
          FROM   #RE_LTR g 
      END 
GO

ALTER PROCEDURE [dbo].[ReportExport_LinkTrackingReportByLinkAndSubscriberFilter] 
@IdCampaign      INT, 
@CampaignStatus  int, 
@IdLink          int, 
@EmailNameFilter varchar(100), 
@FirstNameFilter varchar(100), 
@LastNameFilter  varchar(100) 
AS 
    CREATE TABLE #RE_LTR 
      ( 
         IdSubscriber     bigint, 
         email            varchar(100), 
         firstname        varchar(150), 
         lastname         varchar(150), 
         SubscriberClicks int, 
         LinkURL          varchar(800) 
      ) 

    INSERT INTO #RE_LTR 
    SELECT S.IdSubscriber, 
           S.Email, 
           S.FirstName, 
           S.LastName, 
           SUM(ISNULL(lt.Count, 1)) 
           SubscriberClicks, 
           [dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) UrlLink 
    FROM   LinkTracking LT 
           INNER JOIN Link L WITH(NOLOCK) 
                   ON L.IdLink = LT.IdLink 
           LEFT JOIN Subscriber S WITH(NOLOCK) 
                  ON LT.IdSubscriber = S.IdSubscriber 
    WHERE  L.IdCampaign IN (SELECT IdCampaign 
                            FROM   GetTestABSet(@IdCampaign)) 
           AND L.IdLink = @IdLink 
           AND s.Email like @EmailNameFilter 
           AND ISNULL(s.FirstName, '') like @firstnameFilter 
           AND ISNULL(s.LastName, '') like @lastnameFilter 
    GROUP  BY S.IdSubscriber, 
              S.Email, 
              S.FirstName, 
              S.LastName, 
              lt.IdLink 

    -- Custom Fields      
    declare @sql varchar(max) 
    declare @sql2 varchar(max) 
    declare @in varchar(max) 
    declare @columns varchar(max) 
    declare @IdField int 
    declare @Name varchar(100) 
    DECLARE cur CURSOR FOR 
      SELECT DISTINCT f.IdField, 
                      f.Name 
      FROM   Field f WITH(NOLOCK) 
             JOIN FieldXSubscriber FxS WITH(NOLOCK) 
               ON f.IdField = FxS.IdField 
             JOIN CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
               ON FxS.IdSubscriber = cdoi.IdSubscriber 
      WHERE  cdoi.IdCampaign IN (SELECT IdCampaign 
                                 FROM   GetTestABSet(@IdCampaign)) 

    set @in='' 
    set @sql='SELECT IdSubscriber' 
    set @columns='' 

    OPEN cur 

    FETCH NEXT FROM cur INTO @IdField, @Name 

    IF ( @@FETCH_STATUS = 0 ) 
      BEGIN 
          set @columns=', [' + @Name + ']' 
          set @in=convert(varchar, @IdField) 

          FETCH NEXT FROM cur INTO @IdField, @Name 

          WHILE @@FETCH_STATUS = 0 
            BEGIN 
                set @columns=@columns + ', [' + @Name + ']' 
                set @in=@in + ',' + convert(varchar, @IdField) 

                FETCH NEXT FROM cur INTO @IdField, @Name 
            END 
      END -- IF       

    CLOSE cur 

    DEALLOCATE cur 

    IF @columns <> '' 
      BEGIN 
          set @sql=@sql + @columns + ' FROM ( Select IdSubscriber, Value, Name From Field F WITH(NOLOCK) join FieldXSubscriber FxS WITH(NOLOCK)  on f.IdField=FxS.IdField  where f.IdField in (' + @in 
                   + ')) po PIVOT (max(Value) FOR Name IN (' + substring(@columns, 3, 100000) 
                   + ')) AS PVT ' 
          set @sql2= 
          'SELECT Email, FirstName, LastName, SubscriberClicks, LinkURL  ' 
          + replace(@columns, '[', 't.[') 
          + ' FROM #RE_LTR g LEFT JOIN (' + @sql 
          + ')t ON g.IdSubscriber=t.IdSubscriber' 

          --print(@sql2)     
          execute(@sql2) 
      END 
    ELSE 
      BEGIN 
          SELECT Email, 
                 FirstName, 
                 LastName, 
                 SubscriberClicks, 
                 LinkURL 
          FROM   #RE_LTR g 
      END 
GO

ALTER PROCEDURE [dbo].[ReportExport_LinkTrackingReportBySubscriberFilter] 
@IdCampaign      INT, 
@CampaignStatus  int, 
@EmailNameFilter varchar(100), 
@FirstNameFilter varchar(100), 
@LastNameFilter  varchar(100) 
AS 
    CREATE TABLE #RE_LTR 
      ( 
         IdSubscriber     bigint, 
         email            varchar(100), 
         firstname        varchar(150), 
         lastname         varchar(150), 
         SubscriberClicks int, 
         LinkURL          varchar(800) 
      ) 

    INSERT INTO #RE_LTR 
    SELECT S.IdSubscriber, 
           S.Email, 
           S.FirstName, 
           S.LastName, 
           SUM(ISNULL(lt.Count, 1)) 
           SubscriberClicks, 
           [dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) UrlLink 
    FROM   LinkTracking LT WITH(NOLOCK) 
           INNER JOIN Link L WITH(NOLOCK) 
                   ON L.IdLink = LT.IdLink 
           LEFT JOIN Subscriber S WITH(NOLOCK) 
                  ON LT.IdSubscriber = S.IdSubscriber 
    WHERE  L.IdCampaign IN (SELECT IdCampaign 
                            FROM   GetTestABSet(@IdCampaign)) 
           AND S.Email like @EmailNameFilter 
           AND ISNULL(S.FirstName, '') like @firstnameFilter 
           AND ISNULL(S.LastName, '') like @lastnameFilter 
    GROUP  BY S.IdSubscriber, 
              S.Email, 
              S.FirstName, 
              S.LastName, 
              lt.IdLink 

    -- Custom Fields      
    declare @sql varchar(max) 
    declare @sql2 varchar(max) 
    declare @in varchar(max) 
    declare @columns varchar(max) 
    declare @IdField int 
    declare @Name varchar(100) 
    DECLARE cur CURSOR FOR 
      SELECT DISTINCT f.IdField, 
                      f.Name 
      FROM   Field f WITH(NOLOCK) 
             JOIN FieldXSubscriber FxS WITH(NOLOCK) 
               ON f.IdField = FxS.IdField 
             JOIN CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
               ON FxS.IdSubscriber = cdoi.IdSubscriber 
      WHERE  cdoi.IdCampaign IN (SELECT IdCampaign 
                                 FROM   GetTestABSet(@IdCampaign)) 

    set @in='' 
    set @sql='SELECT IdSubscriber' 
    set @columns='' 

    OPEN cur 

    FETCH NEXT FROM cur INTO @IdField, @Name 

    IF ( @@FETCH_STATUS = 0 ) 
      BEGIN 
          set @columns=', [' + @Name + ']' 
          set @in=convert(varchar, @IdField) 

          FETCH NEXT FROM cur INTO @IdField, @Name 

          WHILE @@FETCH_STATUS = 0 
            BEGIN 
                set @columns=@columns + ', [' + @Name + ']' 
                set @in=@in + ',' + convert(varchar, @IdField) 

                FETCH NEXT FROM cur INTO @IdField, @Name 
            END 
      END -- IF       

    CLOSE cur 

    DEALLOCATE cur 

    IF @columns <> '' 
      BEGIN 
          set @sql=@sql + @columns + ' FROM (Select IdSubscriber, Value, Name From Field F WITH(NOLOCK) join FieldXSubscriber FxS WITH(NOLOCK)  on f.IdField=FxS.IdField  where f.IdField in (' + @in 
                   + ')) po PIVOT ( max(Value) FOR Name IN (' + substring(@columns, 3, 100000) 
                   + ')) AS PVT ' 
          set @sql2= 
          'SELECT Email, FirstName, LastName, SubscriberClicks, LinkURL  ' 
          + replace(@columns, '[', 't.[') 
          + ' FROM #RE_LTR g  LEFT JOIN (' + @sql 
          + ')t ON g.IdSubscriber=t.IdSubscriber' 

          --print(@sql2)     
          execute(@sql2) 
      END 
    ELSE 
      BEGIN 
          SELECT Email, 
                 FirstName, 
                 LastName, 
                 SubscriberClicks, 
                 LinkURL 
          FROM   #RE_LTR g 
      END 
GO

ALTER PROCEDURE [dbo].[Statistics_LinksByCampaign_GX] @IdCampaign INT 
AS 
  BEGIN 
      SELECT L.IdLink, 
             [dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) UrlLink, 
             SUM(LT.Count)                                          ClickCount, 
             COUNT(LT.Count) 
             UniqueClickCount 
      FROM   Link L WITH(NOLOCK) 
             INNER JOIN LinkTracking LT WITH(NOLOCK) 
                     ON LT.IdLink = L.IdLink 
      WHERE  L.IdCampaign = @IdCampaign 
      GROUP  BY L.IdLink, 
                lt.IdLink 
  END 
GO

ALTER PROCEDURE [dbo].[Statistics_TopClickedLinksByCampaign_GX] @IDCampaign INT, 
                                                                @StartDate 
DATETIME, 
                                                                @EndDate 
DATETIME, 
                                                                @HowMany    INT, 
                                                                @IDStatus   INT 
AS 
  BEGIN 
      SET @StartDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), @StartDate, 101), 
                       101) 
      SET @EndDate = DATEADD(dd, 1, CONVERT(DATETIME, CONVERT(VARCHAR(10), 
                                                      @EndDate, 101), 101)) 

      DECLARE @t TABLE 
        ( 
           idcampaign INT PRIMARY KEY 
        ); 

      INSERT INTO @t 
      SELECT idcampaign 
      FROM   Gettestabset(@IdCampaign) 

      SELECT TOP (@HowMany) LT.IdLink, 
                            SUM(ISNULL(LT.Count, 1)) 
                            ClickCount, 
                            COUNT(ISNULL(LT.Count, 1)) 
                            UniqueClickCount, 
                            [dbo].[GetUrlLinkCustomParsed](@IDCampaign, 
                            lt.IdLink) 
                            UrlLink 
      FROM   @t t 
             JOIN dbo.Link L WITH(NOLOCK) 
               ON t.idcampaign = L.IdCampaign 
             JOIN LinkTracking LT WITH(NOLOCK) 
               ON LT.IdLink = L.IdLink 
      WHERE  LT.[Date] BETWEEN @StartDate AND @EndDate 
      GROUP  BY LT.IdLink, 
                UrlLink 
      ORDER  BY SUM(ISNULL(LT.Count, 1)) DESC 
  END 
GO

ALTER PROCEDURE [dbo].[Statistics_TopClickedLinksByCampaignAndFilter_GX] 
@IDCampaign      INT, 
@StartDate       DATETIME, 
@EndDate         DATETIME, 
@emailFilter     varchar(50), 
@firstnameFilter varchar(50), 
@lastnameFilter  varchar(50), 
@HowMany         INT 
AS 
  BEGIN 
      SET @StartDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), @StartDate, 101), 
                       101) 
      SET @EndDate = DATEADD(dd, 1, CONVERT(DATETIME, CONVERT(VARCHAR(10), 
                                                      @EndDate, 101), 101)) 

      DECLARE @t TABLE 
        ( 
           idcampaign INT PRIMARY KEY 
        ); 

      INSERT INTO @t 
      SELECT idcampaign 
      FROM   Gettestabset(@IdCampaign) 

      SELECT TOP (@HowMany) LT.IdLink, 
                            SUM(ISNULL(LT.Count, 1)) 
                            ClickCount, 
                            COUNT(ISNULL(LT.Count, 1)) 
                            UniqueClickCount, 
                            [dbo].[GetUrlLinkCustomParsed](@IDCampaign, 
                            lt.IdLink) 
                            UrlLink 
      FROM   @t t 
             JOIN dbo.Link L WITH(NOLOCK) 
               ON t.idcampaign = L.IdCampaign 
             JOIN LinkTracking LT WITH(NOLOCK) 
               ON LT.IdLink = L.IdLink 
                  AND LT.[Date] BETWEEN @StartDate AND @EndDate 
             JOIN Subscriber s WITH(NOLOCK) 
               ON s.IdSubscriber = LT.IdSubscriber 
      WHERE  s.Email like @emailFilter 
             AND ISNULL(s.Firstname, '') like @firstnameFilter 
             AND ISNULL(s.lastname, '') like @lastnameFilter 
      GROUP  BY LT.IdLink, 
                UrlLink 
      ORDER  BY SUM(ISNULL(LT.Count, 1)) desc 
  END 