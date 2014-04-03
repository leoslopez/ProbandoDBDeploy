-- =============================================
-- Script Template
-- =============================================
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Subscriber]') AND name = N'IX_Subscriber_IdCampaign')
DROP INDEX [IX_Subscriber_IdCampaign] ON [dbo].[Subscriber] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Subscriber]') AND name = N'IX_Subscribers_UserEmail')
DROP INDEX [IX_Subscribers_UserEmail] ON [dbo].[Subscriber] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Subscriber]') AND name = N'IX_Subscribers_IduserIdSubscribersStatus')
DROP INDEX [IX_Subscribers_IduserIdSubscribersStatus] ON [dbo].[Subscriber] WITH ( ONLINE = OFF )
GO



ALTER TABLE dbo.Subscriber
	ALTER COLUMN [FirstName] NVARCHAR (150) NULL
GO

ALTER TABLE dbo.Subscriber
	ALTER COLUMN [LastName] NVARCHAR (150) NULL
GO

ALTER PROCEDURE [dbo].[Campaigns_GetSubscribersAndCustoms_Hotmail] @IDCampaign INT, 
                                                                   @Amount     INT = 0 
AS 
    DECLARE @t TABLE 
      ( 
         idsubscriber BIGINT, 
         dtype        BIT, 
         id           BIGINT, 
         firstname    NVARCHAR(200), 
         lastname     NVARCHAR(200), 
         email        NVARCHAR(400), 
         iduser       INT, 
         lang         INT, 
         UNIQUE CLUSTERED ( idsubscriber, dtype, id) 
      ) 

    IF ( @Amount > 0 ) 
      BEGIN 
          IF( EXISTS (SELECT TOP 1 cdoi.IdSubscriber 
                      FROM   dbo.CampaignDeliveriesOpenInfo cdoi 
                      WHERE  cdoi.IdCampaign = @IDCampaign) ) 
            BEGIN 
                INSERT INTO @t 
                SELECT TOP (@Amount) S.idsubscriber, 
                                     0              t, 
                                     S.IdSubscriber AS ID, 
                                     S.FirstName, 
                                     S.LastName, 
                                     S.Email, 
                                     S.IDUser, 
                                     0              AS LANG 
                FROM   SubscribersListXCampaign SLXC WITH (NOLOCK) 
                       JOIN dbo.SubscribersList SL WITH (NOLOCK) 
                         ON SLXC.IdSubscribersList = SL.IdSubscribersList 
                       JOIN SubscriberxList SXL WITH (NOLOCK) 
                         ON SL.IdSubscribersList = SXL.IdSubscribersList 
                       JOIN Subscriber S WITH (NOLOCK) 
                         ON S.IdSubscriber = SXL.IdSubscriber 
                       JOIN CampaignXSubscriberStatus cdoi WITH(NOLOCK) 
                         ON s.IdSubscriber = cdoi.IdSubscriber 
                            AND cdoi.IdCampaign = @IDCampaign 
                            AND cdoi.Sent = 0 
                WHERE  ( SLXC.IdCampaign = @IDCampaign ) 
                       AND ( SL.Active = 1 ) 
                       AND ( SXL.Active = 1 ) 
                       AND ( S.IdSubscribersStatus < 3 ) 
                       AND ( ( S.email LIKE '%@hotmail%' ) 
                              OR ( S.email LIKE '%@msn%' ) 
                              OR ( S.email LIKE '%@live%' ) 
                              OR ( S.email LIKE '%@outlook%' ) ) 
                GROUP  BY s.IdSubscriber, 
                          s.FirstName, 
                          s.LastName, 
                          s.Email, 
                          s.IdUser 
            END 
          ELSE 
            BEGIN 
                INSERT INTO @t 
                SELECT TOP (@Amount) S.idsubscriber, 
                                     0              t, 
                                     S.IdSubscriber AS ID, 
                                     S.FirstName, 
                                     S.LastName, 
                                     S.Email, 
                                     S.IDUser, 
                                     0              AS LANG 
                FROM   SubscribersListXCampaign SLXC WITH (NOLOCK) 
                       JOIN dbo.SubscribersList SL WITH (NOLOCK) 
                         ON SLXC.IdSubscribersList = SL.IdSubscribersList 
                       JOIN SubscriberxList SXL WITH (NOLOCK) 
                         ON SL.IdSubscribersList = SXL.IdSubscribersList 
                       JOIN Subscriber S WITH (NOLOCK) 
                         ON S.IdSubscriber = SXL.IdSubscriber 
                WHERE  ( SLXC.IdCampaign = @IDCampaign ) 
                       AND ( SL.Active = 1 ) 
                       AND ( SXL.Active = 1 ) 
                       AND ( S.IdSubscribersStatus < 3 ) 
                       AND ( ( S.email LIKE '%@hotmail%' ) 
                              OR ( S.email LIKE '%@msn%' ) 
                              OR ( S.email LIKE '%@live%' ) 
                              OR ( S.email LIKE '%@outlook%' ) ) 
                GROUP  BY s.IdSubscriber, 
                          s.FirstName, 
                          s.LastName, 
                          s.Email, 
                          s.IdUser 
            END 
      END 
    ELSE 
      BEGIN 
          INSERT INTO @t 
          SELECT DISTINCT S.idsubscriber, 
                          0              t, 
                          S.IdSubscriber AS ID, 
                          S.FirstName, 
                          S.LastName, 
                          S.Email, 
                          S.IDUser, 
                          0              AS LANG 
          FROM   SubscribersListXCampaign SLXC WITH (NOLOCK) 
                 JOIN dbo.SubscribersList SL WITH (NOLOCK) 
                   ON SLXC.IdSubscribersList = SL.IdSubscribersList 
                 JOIN SubscriberxList SXL WITH (NOLOCK) 
                   ON SL.IdSubscribersList = SXL.IdSubscribersList 
                 JOIN Subscriber S WITH (NOLOCK) 
                   ON S.IdSubscriber = SXL.IdSubscriber 
          WHERE  ( SLXC.IdCampaign = @IDCampaign ) 
                 AND ( SL.Active = 1 ) 
                 AND ( SXL.Active = 1 ) 
                 AND ( S.IdSubscribersStatus < 3 ) 
                 AND ( ( S.email LIKE '%@hotmail%' ) 
                        OR ( S.email LIKE '%@msn%' ) 
                        OR ( S.email LIKE '%@live%' ) 
                        OR ( S.email LIKE '%@outlook%' ) ) 
      END 

    DELETE FROM @t 
    FROM   @t T 
           JOIN dbo.BlacklistEmail BLE 
             ON T.Email = BLE.Email 

    INSERT INTO @t 
    SELECT DISTINCT T.idsubscriber, 
                    1, 
                    319         AS ID, 
                    319         AS FIRSTNAME, 
                    319         AS LASTNAME, 
                    S.FirstName AS EMAIL, 
                    T.IdUser, 
                    0           AS LANG 
    FROM   Subscriber S 
           JOIN @t T 
             ON T.idsubscriber = S.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT T.idsubscriber, 
                    1, 
                    320        AS ID, 
                    320        AS FIRSTNAME, 
                    320        AS LASTNAME, 
                    S.LastName AS EMAIL, 
                    T.IdUser, 
                    0          AS LANG 
    FROM   Subscriber S 
           JOIN @t T 
             ON T.idsubscriber = S.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT T.idsubscriber, 
                    1, 
                    321     AS ID, 
                    321     AS FIRSTNAME, 
                    321     AS LASTNAME, 
                    S.Email AS EMAIL, 
                    T.IdUser, 
                    0       AS LANG 
    FROM   Subscriber S 
           JOIN @t T 
             ON T.idsubscriber = S.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT T.idsubscriber, 
                    1, 
                    322      AS ID, 
                    322      AS FIRSTNAME, 
                    322      AS LASTNAME, 
                    S.Gender AS EMAIL, 
                    T.IdUser, 
                    0        AS LANG 
    FROM   Subscriber S 
           JOIN @t T 
             ON T.idsubscriber = S.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT T.idsubscriber, 
                    1, 
                    324    AS ID, 
                    324    AS FIRSTNAME, 
                    324    AS LASTNAME, 
                    C.Name AS EMAIL, 
                    T.IdUser, 
                    0      AS LANG 
    FROM   Subscriber S 
           LEFT JOIN Country C 
                  ON S.IdCountry = C.IdCountry 
           JOIN @t T 
             ON T.idsubscriber = S.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT T.idsubscriber, 
                    1, 
                    323           AS ID, 
                    323           AS FIRSTNAME, 
                    323           AS LASTNAME, 
                    S.UTCBirthday AS EMAIL, 
                    T.IdUser, 
                    0             AS LANG 
    FROM   Subscriber S 
           JOIN @t T 
             ON T.idsubscriber = S.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT T.idsubscriber, 
                    1, 
                    F.IdField AS ID, 
                    F.IdField AS FIRSTNAME, 
                    F.IdField AS LASTNAME, 
                    FXS.Value AS EMAIL, 
                    T.IdUser, 
                    0         AS LANG 
    FROM   ContentXField CXF WITH(NOLOCK) 
           JOIN Field F WITH(NOLOCK) 
             ON F.IdField = CXF.IdField 
           JOIN @t T 
             ON T.iduser = F.IdUser 
                AND T.dtype = 0 
           LEFT JOIN FieldXSubscriber FXS WITH(NOLOCK) 
                  ON FXS.IdField = CXF.IdField 
                     AND T.idsubscriber = FXS.IdSubscriber 
    WHERE  CXF.IdContent = @IDCampaign 

    SELECT dtype, 
           id, 
           firstname, 
           lastname, 
           email, 
           iduser, 
           lang 
    FROM   @t 
    ORDER  BY idsubscriber, 
              dtype, 
              id 

GO


ALTER PROCEDURE [dbo].[Campaigns_GetSubscribersAndCustoms_NOT_Hotmail] @IDCampaign INT, 
                                                                       @Amount     INT = 0 
AS 
    DECLARE @t TABLE 
      ( 
         idsubscriber BIGINT, 
         dtype        BIT, 
         id           BIGINT, 
         firstname    NVARCHAR(200), 
         lastname     NVARCHAR(200), 
         email        NVARCHAR(400), 
         iduser       INT, 
         lang         INT, 
         UNIQUE CLUSTERED ( idsubscriber, dtype, id) 
      ) 

    IF ( @Amount > 0 ) 
      BEGIN 
          IF( EXISTS (SELECT TOP 1 cdoi.IdSubscriber 
                      FROM   dbo.CampaignDeliveriesOpenInfo cdoi 
                      WHERE  cdoi.IdCampaign = @IDCampaign) ) 
            BEGIN 
                INSERT INTO @t 
                SELECT TOP (@Amount) s.idsubscriber, 
                                     0              t, 
                                     s.IdSubscriber AS ID, 
                                     s.FirstName, 
                                     s.LastName, 
                                     s.Email, 
                                     s.IDUser, 
                                     0              AS lang 
                FROM   SubscribersListXCampaign SLxC WITH (NOLOCK) 
                       JOIN dbo.SubscribersList SL WITH (NOLOCK) 
                         ON SLxC.IdSubscribersList = SL.IdSubscribersList 
                       JOIN SubscriberxList SxL WITH (NOLOCK) 
                         ON SL.IdSubscribersList = SXL.IdSubscribersList 
                       JOIN Subscriber s WITH (NOLOCK) 
                         ON s.IdSubscriber = SxL.IdSubscriber 
                       JOIN CampaignXSubscriberStatus cdoi WITH(NOLOCK) 
                         ON s.IdSubscriber = cdoi.IdSubscriber 
                            AND cdoi.IdCampaign = @IDCampaign 
                            AND cdoi.Sent = 0 
                WHERE  ( SLxC.IdCampaign = @IDCampaign ) 
                       AND ( SL.Active = 1 ) 
                       AND ( SxL.Active = 1 ) 
                       AND ( s.IdSubscribersStatus < 3 ) 
                       AND ( s.email NOT LIKE '%@hotmail%' ) 
                       AND ( s.email NOT LIKE '%@msn%' ) 
                       AND ( s.email NOT LIKE '%@live%' ) 
                       AND ( s.email NOT LIKE '%@outlook%' ) 
                GROUP  BY s.IdSubscriber, 
                          s.FirstName, 
                          s.LastName, 
                          s.Email, 
                          s.IdUser 
            END 
          ELSE 
            BEGIN 
                INSERT INTO @t 
                SELECT TOP (@Amount) s.idsubscriber, 
                                     0              t, 
                                     s.IdSubscriber AS ID, 
                                     s.FirstName, 
                                     s.LastName, 
                                     s.Email, 
                                     s.IDUser, 
                                     0              AS lang 
                FROM   SubscribersListXCampaign SLxC WITH (NOLOCK) 
                       JOIN dbo.SubscribersList SL WITH (NOLOCK) 
                         ON SLxC.IdSubscribersList = SL.IdSubscribersList 
                       JOIN SubscriberxList SxL WITH (NOLOCK) 
                         ON SL.IdSubscribersList = SXL.IdSubscribersList 
                       JOIN Subscriber s WITH (NOLOCK) 
                         ON s.IdSubscriber = SxL.IdSubscriber 
                WHERE  ( SLxC.IdCampaign = @IDCampaign ) 
                       AND ( SL.Active = 1 ) 
                       AND ( SxL.Active = 1 ) 
                       AND ( s.IdSubscribersStatus < 3 ) 
                       AND ( s.email NOT LIKE '%@hotmail%' ) 
                       AND ( s.email NOT LIKE '%@msn%' ) 
                       AND ( s.email NOT LIKE '%@live%' ) 
                       AND ( s.email NOT LIKE '%@outlook%' ) 
                GROUP  BY s.IdSubscriber, 
                          s.FirstName, 
                          s.LastName, 
                          s.Email, 
                          s.IdUser 
            END 
      END 
    ELSE 
      BEGIN 
          INSERT INTO @t 
          SELECT DISTINCT s.idsubscriber, 
                          0              t, 
                          s.IdSubscriber AS ID, 
                          s.FirstName, 
                          s.LastName, 
                          s.Email, 
                          s.IDUser, 
                          0              AS lang 
          FROM   SubscribersListXCampaign SLxC WITH (NOLOCK) 
                 JOIN dbo.SubscribersList SL WITH (NOLOCK) 
                   ON SLxC.IdSubscribersList = SL.IdSubscribersList 
                 JOIN SubscriberxList SxL WITH (NOLOCK) 
                   ON SL.IdSubscribersList = SXL.IdSubscribersList 
                 JOIN Subscriber s WITH (NOLOCK) 
                   ON s.IdSubscriber = SxL.IdSubscriber 
          WHERE  ( SLxC.IdCampaign = @IDCampaign ) 
                 AND ( SL.Active = 1 ) 
                 AND ( SxL.Active = 1 ) 
                 AND ( s.IdSubscribersStatus < 3 ) 
                 AND ( s.email NOT LIKE '%@hotmail%' ) 
                 AND ( s.email NOT LIKE '%@msn%' ) 
                 AND ( s.email NOT LIKE '%@live%' ) 
                 AND ( s.email NOT LIKE '%@outlook%' ) 
      END 

    DELETE FROM @t 
    FROM   @t t 
           JOIN dbo.BlacklistDomain bld 
             ON t.Email LIKE bld.domain 

    DELETE FROM @t 
    FROM   @t t 
           JOIN dbo.BlacklistEmail ble 
             ON t.Email = ble.Email 

    INSERT INTO @t 
    SELECT DISTINCT t.idsubscriber, 
                    1, 
                    319         AS ID, 
                    319         AS FirstName, 
                    319         AS LastName, 
                    s.FirstName AS Email, 
                    t.IdUser, 
                    0           AS lang 
    FROM   Subscriber s 
           JOIN @t t 
             ON t.idsubscriber = s.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT t.idsubscriber, 
                    1, 
                    320        AS ID, 
                    320        AS FirstName, 
                    320        AS LastName, 
                    s.LastName AS Email, 
                    t.IdUser, 
                    0          AS lang 
    FROM   Subscriber s 
           JOIN @t t 
             ON t.idsubscriber = s.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT t.idsubscriber, 
                    1, 
                    321     AS ID, 
                    321     AS FirstName, 
                    321     AS LastName, 
                    s.Email AS Email, 
                    t.IdUser, 
                    0       AS lang 
    FROM   Subscriber s 
           JOIN @t t 
             ON t.idsubscriber = s.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT t.idsubscriber, 
                    1, 
                    322      AS ID, 
                    322      AS FirstName, 
                    322      AS LastName, 
                    s.Gender AS Email, 
                    t.IdUser, 
                    0        AS lang 
    FROM   Subscriber s 
           JOIN @t t 
             ON t.idsubscriber = s.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT t.idsubscriber, 
                    1, 
                    324    AS ID, 
                    324    AS FirstName, 
                    324    AS LastName, 
                    c.Name AS Email, 
                    t.IdUser, 
                    0      AS lang 
    FROM   Subscriber s 
           LEFT JOIN Country c 
                  ON s.IdCountry = c.IdCountry 
           JOIN @t t 
             ON t.idsubscriber = s.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT t.idsubscriber, 
                    1, 
                    323           AS ID, 
                    323           AS FirstName, 
                    323           AS LastName, 
                    s.UTCBirthday AS Email, 
                    t.IdUser, 
                    0             AS lang 
    FROM   Subscriber s 
           JOIN @t t 
             ON t.idsubscriber = s.IdSubscriber 

    INSERT INTO @t 
    SELECT DISTINCT t.idsubscriber, 
                    1, 
                    f.IdField AS ID, 
                    f.IdField AS FirstName, 
                    f.IdField AS LastName, 
                    FxS.Value AS Email, 
                    t.IdUser, 
                    0         AS lang 
    FROM   ContentXField CxF WITH(NOLOCK) 
           JOIN Field f WITH(NOLOCK) 
             ON f.IdField = CxF.IdField 
           JOIN @t t 
             ON t.iduser = f.IdUser 
                AND t.dtype = 0 
           LEFT JOIN FieldXSubscriber FxS WITH(NOLOCK) 
                  ON FxS.IdField = CxF.IdField 
                     AND t.idsubscriber = FxS.IdSubscriber 
    WHERE  CxF.IdContent = @IDCampaign 

    SELECT dtype, 
           id, 
           firstname, 
           lastname, 
           email, 
           iduser, 
           lang 
    FROM   @t 
    ORDER  BY idsubscriber, 
              dtype, 
              id 

GO

ALTER PROCEDURE [dbo].[ImportAddSubscriber] @IdUser         INT, 
                                            @Email          VARCHAR(100), 
                                            @FirstName      NVARCHAR(150), 
                                            @LastName       NVARCHAR(150), 
                                            @Gender         CHAR(1), 
                                            @UTCBirthday    DATE, 
                                            @IdCountry      INT, 
                                            @PlanType       SMALLINT, 
                                            @MaxSubscribers INT 
AS 
  BEGIN 
      DECLARE @AmountSubscribers INT 
      DECLARE @tempTable TABLE 
        ( 
           MergeAction        VARCHAR(20), 
           IDSubscriber       INT, 
           IdSubscriberStatus INT 
        ) 

      IF( @PlanType IN ( 1, 4 ) ) 
        BEGIN 
            SELECT @AmountSubscribers = CASE 
                                          --Free  
                                          WHEN @PlanType = 1 THEN (SELECT COUNT(IdSubscriber)
                                                                   FROM   dbo.Subscriber s WITH(NOLOCK)
                                                                   WHERE  s.IdUser = @IdUser 
                                                                          AND s.IdSubscribersStatus <> 7)
                                          --Subscriber  
                                          WHEN @PlanType = 4 THEN (SELECT COUNT(IdSubscriber)
                                                                   FROM   dbo.Subscriber s  WITH(NOLOCK)
                                                                   WHERE  s.IdUser = @IdUser 
                                                                          AND s.IdSubscribersStatus IN( 1, 2, 6 ))
                                          ELSE 0 
                                        END 
        END 
      ELSE 
        SET @AmountSubscribers = 0 

      -- If a record exists, increment a counter by one; otherwise, insert the record with a value of one. The following MERGE statement wraps this logic and uses the HOLDLOCK hint to avoid race conditions.  
      MERGE [dbo].[Subscriber] WITH(HOLDLOCK) AS [Target] 
      USING (SELECT 1 AS One) AS [Source] 
      ON ( [Target].Email = @Email 
           AND [Target].IdUser = @IdUser ) 
      WHEN MATCHED AND [Target].IdSubscribersStatus IN (1, 2, 7) THEN 
        UPDATE SET [Target].Gender = @Gender, 
                   [Target].UTCBirthday = @UTCBirthday, 
                   [Target].IdCountry = @IdCountry, 
                   [Target].FirstName = @FirstName, 
                   [Target].LastName = @LastName,
                   [Target].IdSubscribersStatus = CASE 
													WHEN [Target].IdSubscribersStatus = 2 THEN 1
													ELSE [Target].IdSubscribersStatus
												  END
      WHEN NOT MATCHED AND @MaxSubscribers > @AmountSubscribers THEN 
        INSERT ([IdUser], 
                [Email], 
                [Gender], 
                [UTCBirthday], 
                [IdCountry], 
                [FirstName], 
                [LastName], 
                IdSubscribersStatus, 
                IdSubscriberSourceType, 
                UTCCreationDate) 
        VALUES (@IdUser, 
                @Email, 
                @Gender, 
                @UTCBirthday, 
                @IdCountry, 
                @FirstName, 
                @LastName, 
                1, 
                2, 
                GETUTCDATE()) 
      OUTPUT $action, 
             INSERTED.IdSubscriber, 
             INSERTED.IdSubscribersStatus 
      INTO @tempTable; 

      IF @@ROWCOUNT > 0 
        BEGIN 
            SELECT tt.IDSubscriber, 
                   case 
                     WHEN tt.MergeAction = 'UPDATE' then 1 
                     else 0 
                   END as WasUpdate, 
                   case 
                     WHEN tt.MergeAction = 'INSERT' then 1 
                     else 0 
                   END as WasInsert, 
                   case 
                     WHEN @AmountSubscribers + 1 < @MaxSubscribers THEN 0 
                     WHEN tt.MergeAction = 'INSERT' 
                          AND @AmountSubscribers + 1 >= @MaxSubscribers then 1 
                     WHEN tt.MergeAction = 'UPDATE' 
                          AND @AmountSubscribers >= @MaxSubscribers then 1 
                     else 0 
                   END as Reached, 
                   tt.IdSubscriberStatus 
            FROM   @tempTable tt 
        END 
      ELSE 
        BEGIN 
            DECLARE @IdSubscriber BIGINT 
            DECLARE @IdSubscribersStatus INT 

            SET @IdSubscriber = 0 
            SET @IdSubscribersStatus = 0 

            SELECT @IdSubscriber = s.IdSubscriber, 
                   @IdSubscribersStatus = s.IdSubscribersStatus 
            FROM   dbo.Subscriber s  WITH(NOLOCK)
            WHERE  s.IdUser = @IdUser 
                   and s.Email = @Email 
                   AND s.IdSubscribersStatus IN ( 3, 4, 5, 6, 8 ) 

            IF @IdSubscriber > 0 
              SELECT @IdSubscriber, 
                     0                    WasUpdate, 
                     0                    WasInsert, 
                     0                    Reached, 
                     @IdSubscribersStatus IdSubscriberStatus 
            ELSE 
              SELECT null IDSubscriber, 
                     0    WasUpdate, 
                     0    WasInsert, 
                     1    Reached, 
                     0    IdSubscriberStatus 
        END 
  END 

GO

CREATE NONCLUSTERED INDEX [IX_Subscriber_IdCampaign]
    ON [dbo].[Subscriber]([IdCampaign] ASC, [UTCUnsubDate] ASC)
    INCLUDE([Email], [FirstName], [LastName]) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [Subscriber];
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Subscribers_UserEmail]
    ON [dbo].[Subscriber]([IdUser] ASC, [Email] ASC)
    INCLUDE([FirstName], [LastName], [IdSubscriber], [IdSubscribersStatus]) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];
GO

CREATE NONCLUSTERED INDEX [IX_Subscribers_IduserIdSubscribersStatus]
    ON [dbo].[Subscriber]([IdUser] ASC, [IdSubscribersStatus] ASC)
    INCLUDE([Email], [FirstName], [LastName], [UTCCreationDate]) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [Subscriber];


GO

ALTER TABLE dbo.Content
	ALTER COLUMN [Content] NVARCHAR (MAX) NULL
GO

ALTER TABLE dbo.Content
	ALTER COLUMN [PlainText] NVARCHAR (MAX) NULL

GO

/*-------------------------REPORTS----------------------------*/

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ReportRequest]') AND name = N'IX_ReportRequest_ProgressActive')
DROP INDEX [IX_ReportRequest_ProgressActive] ON [dbo].[ReportRequest] WITH ( ONLINE = OFF )

GO

ALTER TABLE dbo.ReportRequest
	ALTER COLUMN [FirstNameFilter] NVARCHAR (50) NULL
GO

ALTER TABLE dbo.ReportRequest
	ALTER COLUMN [LastNameFilter] NVARCHAR (50) NULL

GO

CREATE NONCLUSTERED INDEX [IX_ReportRequest_ProgressActive]
    ON [dbo].[ReportRequest]([Progress] ASC, [Active] ASC)
    INCLUDE([IdRequest], [IdCampaign], [ReportType], [RequestExportType], [Status], [TimeStamp], [Language], [URLPath], [FileName], [EmailAlert], [Filter], [FirstNameFilter], [LastNameFilter], [EmailFilter], [IdCampaignStatus]) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];

GO

ALTER PROCEDURE [dbo].[ReportExport_AperturesClicksReport] 
@IdCampaign     INT, 
@CampaignStatus INT 
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
LEFT JOIN (SELECT LT.IdSubscriber, 
			SUM(LT.Count) as SubscriberClicks 
			FROM @t t 
			JOIN Link L WITH(NOLOCK) 
			on t.IdCampaign = L.IdCampaign 
			JOIN LinkTracking LT WITH(NOLOCK) 
			ON LT.IdLink = L.IdLink 
			GROUP BY LT.IdSubscriber) LT 
ON Lt.IdSubscriber = cdoi.IdSubscriber 
WHERE cdoi.IdDeliveryStatus = 100 

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
      FROM   @t t 
             JOIN CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
               on t.IdCampaign = cdoi.IdCampaign 
             JOIN FieldXSubscriber FxS WITH(NOLOCK) 
               ON FxS.IdSubscriber = cdoi.IdSubscriber 
             JOIN Field f WITH(NOLOCK) 
               ON f.IdField = FxS.IdField 
      WHERE  cdoi.IdDeliveryStatus = 100 

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
          set @sql=@sql + @columns 
                   + ' FROM ( Select IdSubscriber, Value, Name From Field F WITH(NOLOCK) join FieldXSubscriber FxS WITH(NOLOCK) on f.IdField=FxS.IdField where f.IdField in ('
                   + @in 
                   + ')) po PIVOT (max(Value) FOR Name IN (' 
                   + substring(@columns, 3, 100000) + ')) AS PVT ' 
          set @sql2='SELECT Email, FirstName, LastName, SubscriberClicks' 
                    + replace(@columns, '[', 't.[') 
                    + ' FROM #RE_ACR g LEFT JOIN (' + @sql 
                    + ')t ON g.IdSubscriber=t.IdSubscriber' 

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

ALTER PROCEDURE [dbo].[ReportExport_AperturesClicksReportByDay] 
@IdCampaign     INT, 
@CampaignStatus INT, 
@ApertureDay    DATETIME 
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
WHERE  cdoi.IdDeliveryStatus = 100 
AND CONVERT(VARCHAR(10), @ApertureDay, 101) = CONVERT(VARCHAR(10), cdoi.Date, 101)

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
      FROM   @t t 
             JOIN CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
               on t.IdCampaign = cdoi.IdCampaign 
             JOIN FieldXSubscriber FxS WITH(NOLOCK) 
               ON FxS.IdSubscriber = cdoi.IdSubscriber 
             JOIN Field f WITH(NOLOCK) 
               ON f.IdField = FxS.IdField 
      WHERE  cdoi.IdDeliveryStatus = 100 

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
          set @sql=@sql + @columns 
                   + ' FROM (Select IdSubscriber, Value, Name From Field F WITH(NOLOCK) join FieldXSubscriber FxS WITH(NOLOCK) on f.IdField=FxS.IdField where f.IdField in ('
                   + @in 
                   + ')) po PIVOT (max(Value) FOR Name IN (' 
                   + substring(@columns, 3, 100000) + ')) AS PVT ' 
          set @sql2='SELECT Email, FirstName, LastName, SubscriberClicks' 
                    + replace(@columns, '[', 't.[') 
                    + ' FROM #RE_ACR g LEFT JOIN (' + @sql 
                    + ')t ON g.IdSubscriber=t.IdSubscriber' 

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

ALTER PROCEDURE [dbo].[ReportExport_AperturesClicksReportByDayAndSubscriberFilter] 
@IdCampaign      INT, 
@CampaignStatus  INT,
@ApertureDay     DATETIME,
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
AND CONVERT(VARCHAR(10), @ApertureDay, 101) = CONVERT(VARCHAR(10), cdoi.Date, 101)
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
      FROM   @t t 
             JOIN CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
               on t.IdCampaign = cdoi.IdCampaign 
             JOIN FieldXSubscriber FxS WITH(NOLOCK) 
               ON FxS.IdSubscriber = cdoi.IdSubscriber 
             JOIN Field f WITH(NOLOCK) 
               ON f.IdField = FxS.IdField 
      WHERE  cdoi.IdDeliveryStatus = 100 

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
          set @sql=@sql + @columns 
                   + ' FROM (Select IdSubscriber, Value, Name From Field F WITH(NOLOCK) join FieldXSubscriber FxS WITH(NOLOCK) on f.IdField=FxS.IdField where f.IdField in ('
                   + @in 
                   + ')) po PIVOT (max(Value) FOR Name IN (' 
                   + substring(@columns, 3, 100000) + ')) AS PVT ' 
          set @sql2='SELECT Email, FirstName, LastName, SubscriberClicks' 
                    + replace(@columns, '[', 't.[') 
                    + ' FROM #RE_ACR gLEFT JOIN (' + @sql 
                    + ')t ON g.IdSubscriber=t.IdSubscriber' 

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

ALTER PROCEDURE [dbo].[ReportExport_AperturesClicksReportBySubscriberFilter] 
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

ALTER PROCEDURE [dbo].[ReportExport_DeliveryReport]
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

GO

ALTER PROCEDURE [dbo].[ReportExport_DeliveryReportByStatus]        
@IdCampaign INT,            
@CampaignStatus int,              
@MailDeliveryStatusID int -- NotOpened = 0,Bounced = 1,Opened = 2,NotSent = 3                  
AS            
SET NOCOUNT ON

DECLARE @IdDeliveryStatus int        
        
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
FROM @t t
JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)
ON t.IdCampaign=cdoi.IdCampaign 
JOIN dbo.Subscriber S WITH(NOLOCK)                        
ON S.IdSubscriber = cdoi.IdSubscriber            
WHERE cdoi.IdDeliveryStatus BETWEEN 1 AND 8        
END        
ELSE        
BEGIN       
SELECT @IdDeliveryStatus=        
CASE @MailDeliveryStatusID        
WHEN 0 THEN 0        
WHEN 2 THEN 100     
WHEN 3 THEN 101 END        
    
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
WHERE cdoi.IdDeliveryStatus=@IdDeliveryStatus                   
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
FROM Field f  WITH(NOLOCK)       
JOIN ContentXField CxF   WITH(NOLOCK)
ON f.IdField=CxF.IdField   
WHERE CxF.IdContent IN (SELECT IdCampaign FROM GetTestABSet(@IdCampaign))              
AND f.Active=1  AND f.IsBasicField =0  
              
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

GO

ALTER PROCEDURE [dbo].[ReportExport_DeliveryReportByStatusAndSubscriberFilter]
@IdCampaign INT,    
@CampaignStatus int,      
@MailDeliveryStatusID int, -- NotOpened = 0,Bounced = 1,Opened = 2,NotSent = 3          
@EmailNameFilter varchar(100),     
@FirstNameFilter nvarchar(100),     
@LastNameFilter nvarchar(100)
AS    
SET NOCOUNT ON

DECLARE @IdDeliveryStatus int

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
FROM @t t
JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)    
ON t.IdCampaign=cdoi.IdCampaign 
JOIN dbo.Subscriber S WITH(NOLOCK)    
ON S.IdSubscriber = cdoi.IdSubscriber    
WHERE cdoi.IdDeliveryStatus BETWEEN 1 AND 8           
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
FROM @t t
JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)    
ON t.IdCampaign=cdoi.IdCampaign 
JOIN dbo.Subscriber S WITH(NOLOCK)    
ON S.IdSubscriber = cdoi.IdSubscriber    
WHERE cdoi.IdDeliveryStatus=@IdDeliveryStatus           
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
FROM Field f WITH(NOLOCK)
JOIN FieldXSubscriber FxS  WITH(NOLOCK) ON f.IdField=FxS.IdField
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
@FirstNameFilter nvarchar(100),     
@LastNameFilter nvarchar(100)
AS    
SET NOCOUNT ON

DECLARE @IdDeliveryStatus int

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
WHERE s.Email like @EmailNameFilter
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
SET NOCOUNT ON

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname nvarchar(150),  
lastname nvarchar(150),  
Unsubdate datetime 
)  
DECLARE @t TABLE ( 
IdCampaign INT PRIMARY KEY ); 

INSERT INTO @t 
SELECT IdCampaign 
FROM GetTestABSet(@IdCampaign)

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, s.UTCUnsubDate
FROM @t t
JOIN dbo.Subscriber S WITH(NOLOCK)       
ON s.IdCampaign=t.IdCampaign 

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
 join FieldXSubscriber FxS  WITH(NOLOCK)
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
Unsubdate datetime 
)  
DECLARE @t TABLE ( 
IdCampaign INT PRIMARY KEY ); 

INSERT INTO @t 
SELECT IdCampaign 
FROM GetTestABSet(@IdCampaign)

INSERT INTO #RE_LTR    
SELECT S.IdSubscriber, S.Email, S.FirstName, S.LastName, s.UTCUnsubDate
FROM @t t
JOIN dbo.Subscriber S WITH(NOLOCK)       
ON s.IdCampaign=t.IdCampaign      
WHERE s.Email like @EmailNameFilter
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
 From Field F   WITH(NOLOCK)    
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

GO

ALTER PROCEDURE [dbo].[ReportExport_GeolocationReport] 
@IdCampaign INT,    
@CampaignStatus int
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

ALTER PROCEDURE [dbo].[ReportExport_GeolocationReportByCity]
@IdCampaign INT,    
@CampaignStatus int,  
@CountryCode varchar(2),  
@Latitude float,  
@Longitude float    
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
ON t.IdCampaign=c.IdCampaign 
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

ALTER PROCEDURE [dbo].[ReportExport_GeolocationReportByCityAndSubscriberFilter]
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

ALTER PROCEDURE [dbo].[ReportExport_GeolocationReportByCountry]
@IdCampaign INT,    
@CampaignStatus int,  
@CountryCode varchar(2)  
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
WHERE c.IdDeliveryStatus=100 AND co.Code=@CountryCode
GROUP BY S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
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
WHERE c.IdDeliveryStatus=100 AND co.Code=@CountryCode
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

ALTER PROCEDURE [dbo].[ReportExport_LinkTrackingReport] 
@IdCampaign     INT, 
@CampaignStatus int 
AS 
SET NOCOUNT ON

CREATE TABLE #RE_LTR ( 
IdSubscriber     bigint, 
email            varchar(100), 
firstname        nvarchar(150), 
lastname         nvarchar(150), 
SubscriberClicks int, 
LinkURL          varchar(800) 
) ;
DECLARE @t TABLE ( 
IdCampaign INT PRIMARY KEY ); 

INSERT INTO @t 
SELECT IdCampaign 
FROM GetTestABSet(@IdCampaign);

INSERT INTO #RE_LTR 
SELECT S.IdSubscriber, 
S.Email, 
S.FirstName, 
S.LastName, 
SUM(ISNULL(lt.Count, 1)) 
SubscriberClicks, 
[dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) UrlLink 
FROM @t t
INNER JOIN Link L WITH(NOLOCK) 
ON t.IdCampaign=l.IdCampaign 
JOIN LinkTracking LT WITH(NOLOCK)
ON L.IdLink = LT.IdLink 
LEFT JOIN Subscriber S WITH(NOLOCK) 
ON LT.IdSubscriber = S.IdSubscriber 
GROUP BY S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
[dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) 

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
          set @sql=@sql + @columns + ' FROM (Select IdSubscriber, Value, Name From Field F   WITH(NOLOCK) join FieldXSubscriber FxS  WITH(NOLOCK)     on f.IdField=FxS.IdField      
          where  f.IdField in (' + @in 
                   + ') ) po PIVOT ( max(Value) FOR Name IN (' + substring(@columns, 3, 100000) 
                   + ')) AS PVT ' 
          set @sql2= 
          'SELECT Email, FirstName, LastName, SubscriberClicks, LinkURL  ' 
          + replace(@columns, '[', 't.[') 
          + ' FROM #RE_LTR g LEFT JOIN (' + @sql 
          + ')t ON g.IdSubscriber=t.IdSubscriber' 

          --print( @sql2 ) 

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

ALTER PROCEDURE [dbo].[ReportExport_LinkTrackingReportByLink] 
@IdCampaign INT, 
@CampaignStatus int, 
@IdLink int 
AS 
SET NOCOUNT ON

CREATE TABLE #RE_LTR ( 
IdSubscriber     bigint, 
email            varchar(100), 
firstname        nvarchar(150), 
lastname         nvarchar(150), 
SubscriberClicks int, 
LinkURL          varchar(800) 
) ;
DECLARE @t TABLE ( 
IdCampaign INT PRIMARY KEY ); 

INSERT INTO @t 
SELECT IdCampaign 
FROM GetTestABSet(@IdCampaign);

INSERT INTO #RE_LTR 
SELECT S.IdSubscriber, 
S.Email, 
S.FirstName, 
S.LastName, 
SUM(ISNULL(lt.Count, 1)) 
SubscriberClicks, 
[dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) UrlLink 
FROM @t t
INNER JOIN Link L WITH(NOLOCK) 
ON t.IdCampaign=l.IdCampaign 
JOIN LinkTracking LT WITH(NOLOCK)
ON L.IdLink = LT.IdLink 
LEFT JOIN Subscriber S WITH(NOLOCK) 
ON LT.IdSubscriber = S.IdSubscriber 
WHERE L.IdLink = @IdLink 
GROUP BY S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
[dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) 

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
@FirstNameFilter nvarchar(100), 
@LastNameFilter  nvarchar(100) 
AS 
SET NOCOUNT ON

CREATE TABLE #RE_LTR ( 
IdSubscriber     bigint, 
email            varchar(100), 
firstname        nvarchar(150), 
lastname         nvarchar(150), 
SubscriberClicks int, 
LinkURL          varchar(800) 
) ;
DECLARE @t TABLE ( 
IdCampaign INT PRIMARY KEY ); 

INSERT INTO @t 
SELECT IdCampaign 
FROM GetTestABSet(@IdCampaign);

INSERT INTO #RE_LTR 
SELECT S.IdSubscriber, 
S.Email, 
S.FirstName, 
S.LastName, 
SUM(ISNULL(lt.Count, 1)) 
SubscriberClicks, 
[dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) UrlLink 
FROM @t t
INNER JOIN Link L WITH(NOLOCK) 
ON t.IdCampaign=l.IdCampaign 
JOIN LinkTracking LT WITH(NOLOCK)
ON L.IdLink = LT.IdLink 
LEFT JOIN Subscriber S WITH(NOLOCK) 
ON LT.IdSubscriber = S.IdSubscriber 
WHERE L.IdLink = @IdLink 
AND s.Email like @EmailNameFilter 
AND ISNULL(s.FirstName, '') like @firstnameFilter 
AND ISNULL(s.LastName, '') like @lastnameFilter 
GROUP BY S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
[dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) 

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
@FirstNameFilter nvarchar(100), 
@LastNameFilter  nvarchar(100) 
AS 
SET NOCOUNT ON

CREATE TABLE #RE_LTR ( 
IdSubscriber     bigint, 
email            varchar(100), 
firstname        nvarchar(150), 
lastname         nvarchar(150), 
SubscriberClicks int, 
LinkURL          varchar(800) 
) ;
DECLARE @t TABLE ( 
IdCampaign INT PRIMARY KEY ); 

INSERT INTO @t 
SELECT IdCampaign 
FROM GetTestABSet(@IdCampaign);

INSERT INTO #RE_LTR 
SELECT S.IdSubscriber, 
S.Email, 
S.FirstName, 
S.LastName, 
SUM(ISNULL(lt.Count, 1)) 
SubscriberClicks, 
[dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink) UrlLink 
FROM @t t
INNER JOIN Link L WITH(NOLOCK) 
ON t.IdCampaign=l.IdCampaign 
JOIN LinkTracking LT WITH(NOLOCK)
ON L.IdLink = LT.IdLink 
LEFT JOIN Subscriber S WITH(NOLOCK) 
ON LT.IdSubscriber = S.IdSubscriber 
WHERE S.Email like @EmailNameFilter 
AND ISNULL(S.FirstName, '') like @firstnameFilter 
AND ISNULL(S.LastName, '') like @lastnameFilter 
GROUP BY S.IdSubscriber, S.Email, S.FirstName, S.LastName, 
[dbo].[GetUrlLinkCustomParsed](@IDCampaign, lt.IdLink)

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

ALTER PROCEDURE [dbo].[ReportExport_RequestWithFilterAndSubscriberFilter_A]
@IdCampaign int,
@IdCampaignStatus int,
@ReportType varchar(100),
@RequestExportType varchar(100),
@Status varchar(50),
@Language varchar(50),
@Filter varchar(200),
@EmailFilter varchar(50),
@FirstNameFilter  nvarchar(50),
@LastNameFilter nvarchar(50),
@EmailAlert varchar(250)
AS
BEGIN TRY
BEGIN TRAN
DELETE FROM ReportRequest WITH(ROWLOCK)
WHERE IdCampaign=@IdCampaign AND @ReportType=ReportType

INSERT INTO ReportRequest(IdCampaign, IdCampaignStatus, ReportType, RequestExportType,
[Status], [Language], Filter, EmailFilter, FirstNameFilter, LastNameFilter, EmailAlert)
VALUES(@IdCampaign, @IdCampaignStatus, @ReportType, @RequestExportType, @Status,
@Language, @Filter, @EmailFilter, @FirstNameFilter, @LastNameFilter, @EmailAlert)
SELECT SCOPE_IDENTITY()
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
END CATCH

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

GO

ALTER PROCEDURE [dbo].[ReportExport_SocialNetworkReportBySocialNetworkAndSubscriberFilter]
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

GO

ALTER PROCEDURE [dbo].[ReportExport_SocialNetworkReportBySocialNetworkListAndSubscriberFilter]
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

GO

ALTER PROCEDURE [dbo].[ReportExport_SocialNetworksReport]
@IdCampaign INT,    
@CampaignStatus int
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname nvarchar(150),  
lastname nvarchar(150),  
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
firstname nvarchar(150),  
lastname nvarchar(150),  
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
@FirstNameFilter nvarchar(100),   
@LastNameFilter nvarchar(100)
AS    

CREATE TABLE #RE_LTR  
(  
IdSubscriber bigint,  
email varchar(100),  
firstname nvarchar(150),  
lastname nvarchar(150),  
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
firstname nvarchar(150),    
lastname nvarchar(150),    
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
@FirstNameFilter nvarchar(100),   
@LastNameFilter nvarchar(100)  
AS  
CREATE TABLE #RE_ACR    
(    
IdSubscriber bigint,    
email varchar(100),    
firstname nvarchar(150),    
lastname nvarchar(150),    
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

ALTER TABLE dbo.Downloads
	ALTER COLUMN [SearchText] NVARCHAR (100) NULL
GO

