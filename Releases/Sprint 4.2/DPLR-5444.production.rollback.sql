PRINT N'Dropping [dbo].[Mucama]...';


GO
DROP PROCEDURE [dbo].[Mucama];


GO
PRINT N'Altering [dbo].[Campaign]...';


GO
ALTER TABLE [dbo].[Campaign] DROP COLUMN [DistinctOpenedMailCount], COLUMN [ForwardedEmailsCount], COLUMN [HardBouncedMailCount], COLUMN [LastOpenedEmailDate], COLUMN [SoftBouncedMailCount], COLUMN [TotalOpenedMailCount], COLUMN [TotalSubscribersLists], COLUMN [UnopenedMailCount], COLUMN [UnsubscriptionsCount];


GO
PRINT N'Altering [dbo].[Campaigns_TopCampaignsByNameFilter_GX]...';


GO
ALTER PROCEDURE [dbo].[Campaigns_TopCampaignsByNameFilter_GX]   
@IDUser INT,    
@Top INT,    
@Filter VARCHAR(100)    
AS    
SET NOCOUNT ON 

DECLARE @CGCP_GX TABLE (    
IdCampaign INT,    
[Status] INT,    
UTCSentDate datetime )    

DECLARE @GTABS TABLE (    
IdCampaign INT )  

DECLARE @IDCampaign INT    
DECLARE @Status INT    
    
SET ROWCOUNT @Top    
    
INSERT INTO @CGCP_GX (IdCampaign, [Status], UTCSentDate)    
SELECT C.IdCampaign, C.Status, ISNULL(C.UTCSentDate,'2012-11-01') as SentDate    
FROM Campaign C WITH(NOLOCK)    
WHERE C.IdUser=@IDUser    
AND c.Active = 1    
AND [Status] IN (5,6,9)    
AND ([Name] LIKE @Filter OR [Subject] LIKE @Filter)   
ORDER BY UTCSentDate DESC 

INSERT INTO @GTABS
SELECT [dbo].[GetIdCampaignTestAB](t.IdCampaign) as IdCampaign 
FROM @CGCP_GX t
    
SELECT C.IdCampaign, C.[Name], ISNULL(c.UTCSentDate,'2012-11-01 00:00:00') as UTCSentDate, C.[Subject], C.CampaignType,    
DistinctOpenedMailCount, HardBouncedMailCount, SoftBouncedMailCount, UnopenedMailCount,    
C.Status, C.CampaignType, CAST(ISNULL(C.IdTestAB, 0) as BIT) as IsTestAB    
FROM dbo.Campaign c WITH(NOLOCK)    
JOIN @CGCP_GX t    
ON C.IdCampaign = t.IdCampaign    
LEFT JOIN (    
SELECT cdoi.IdCampaign,    
COUNT(CASE IdDeliveryStatus WHEN 0 THEN 0 END) UnopenedMailCount,    
COUNT(CASE IdDeliveryStatus WHEN 2 THEN 2    
WHEN 8 THEN 2 END) HardBouncedMailCount,    
COUNT(CASE IdDeliveryStatus WHEN 1 THEN 1    
WHEN 3 THEN 1    
WHEN 4 THEN 1    
WHEN 5 THEN 1    
WHEN 6 THEN 1    
WHEN 7 THEN 1 END) SoftBouncedMailCount,    
SUM(CASE IdDeliveryStatus WHEN 100 THEN 1 END) DistinctOpenedMailCount    
FROM CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK)    
GROUP BY cdoi.IdCampaign) t1    
ON c.IdCampaign=t1.IdCampaign    
WHERE (C.TestABCategory = 3 OR C.TestABCategory IS NULL)    
ORDER BY UTCSentDate DESC
GO
PRINT N'Altering [dbo].[Campaigns_CampaignSentCampaignByID_GX]...';


GO

ALTER PROCEDURE [dbo].[Campaigns_CampaignSentCampaignByID_GX] @IdCampaign INT 
AS 
    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   GetTestABSet(@IdCampaign); 

    SELECT C.IdCampaign, 
           C.[Name], 
           SENTDATE.UTCSentDate, 
           C.[Subject], 
           [dbo].[CampaignTypeToInt](c.CampaignType, ContentType) AS CampaignTypeInt, 
           ISNULL(DistinctOpenedMailCount, 0)                     AS DistinctOpenedMailCount,
           ISNULL(HardBouncedMailCount, 0)                        AS HardBouncedMailCount, 
           ISNULL(SoftBouncedMailCount, 0)                        AS SoftBouncedMailCount, 
           ISNULL(UnopenedMailCount, 0)                           AS UnopenedMailCount, 
           C.Status, 
           C.EnabledShareSocialNetwork, 
           C.CampaignType, 
           CAST(ISNULL(C.IdTestAB, 0) as BIT)                     as IsTestAB, 
           ISNULL(T.SamplingPercentage, 0)                        as SamplingPercentage, 
           ISNULL(T.TestType, 0)                                  as TestABType, 
           C.IdUser                                               as clientID 
    FROM   dbo.Campaign c WITH(NOLOCK) 
           LEFT JOIN (SELECT @IdCampaign IdCampaign, 
                             COUNT(CASE IdDeliveryStatus 
                                     WHEN 0 THEN 0 
                                   END)  UnopenedMailCount, 
                             COUNT(CASE IdDeliveryStatus 
                                     WHEN 2 THEN 2 
                                     WHEN 8 THEN 2 
                                   END)  HardBouncedMailCount, 
                             COUNT(CASE IdDeliveryStatus 
                                     WHEN 1 THEN 1 
                                     WHEN 3 THEN 1 
                                     WHEN 4 THEN 1 
                                     WHEN 5 THEN 1 
                                     WHEN 6 THEN 1 
                                     WHEN 7 THEN 1 
                                   END)  SoftBouncedMailCount, 
                             SUM(CASE IdDeliveryStatus 
                                   WHEN 100 THEN 1 
                                 END)    DistinctOpenedMailCount
                             
                      FROM   @t t 
                             JOIN CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
                               ON t.IdCampaign = cdoi.IdCampaign 
                     ) OPENS 
                  ON C.IdCampaign = OPENS.IdCampaign 
           LEFT JOIN TestAB T 
                  ON T.IdTestAB = C.IdTestAB 
           JOIN (SELECT MIN(c.UTCSentDate) UTCSentDate, @IdCampaign IdCampaign FROM @t t JOIN dbo.Campaign c on t.IdCampaign = c.IdCampaign ) SENTDATE on SENTDATE.IdCampaign = c.IdCampaign
    WHERE  C.IdCampaign = @IdCampaign
GO
PRINT N'Altering [dbo].[Campaigns_CampaignsForDashboardReportDetails_GX]...';


GO

ALTER PROCEDURE [dbo].[Campaigns_CampaignsForDashboardReportDetails_GX] @IdCampaign     int, 
                                                                        @CampaignStatus int 
AS 
    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   GetTestABSet(@IdCampaign) 

    SELECT c.Name, 
           MAX(c.[Subject])                   [Subject], 
           c.ContentType, 
           SUM(OPENS.DistinctOpenedMailCount) DistinctOpenedMailCount, 
           SUM(SoftBouncedMailCount)          SoftBouncedMailCount, 
           SUM(HardBouncedMailCount)          HardBouncedMailCount, 
           SUM(UnopenedMailCount)             UnopenedMailCount, 
           MIN(c.UTCSentDate)                 UTCSentDate, 
           SUM(F.ForwardedEmailsCount)        ForwardedEmailsCount, 
           SUM(OPENS.TotalOpenedMailCount)    TotalOpenedMailCount, 
           MAX(OPENS.LastOpenedEmailDate)     LastOpenedEmailDate, 
           SUM(CLT.DistinctClickedMailCount)  DistinctClickedMailCount, 
           SUM(CLT.TotalClickedMailCount)     TotalClickedMailCount, 
           MAX(CLT.LastClickedEmailDate)      LastClickedEmailDate, 
           SUM(s.UnsubscriptionsCount)        UnsubscriptionsCount, 
           c.CampaignType, 
           CAST(ISNULL(C.IdTestAB, 0) as BIT) as IsTestAB 
    FROM   @t t 
           JOIN dbo.Campaign c WITH(NOLOCK) 
             ON t.IdCampaign = c.IdCampaign 
           JOIN (SELECT CDU.IdCampaign, 
                        COUNT(CASE IdDeliveryStatus 
                                WHEN 0 THEN 0 
                              END) UnopenedMailCount, 
                        COUNT(CASE IdDeliveryStatus 
                                WHEN 2 THEN 2 
                                WHEN 8 THEN 2 
                              END) HardBouncedMailCount, 
                        COUNT(CASE IdDeliveryStatus 
                                WHEN 1 THEN 1 
                                WHEN 3 THEN 1 
                                WHEN 4 THEN 1 
                                WHEN 5 THEN 1 
                                WHEN 6 THEN 1 
                                WHEN 7 THEN 1 
                              END) SoftBouncedMailCount, 
                        SUM(CASE IdDeliveryStatus 
                              WHEN 100 THEN ISNULL(CDU.Count, 1) 
                            END)   TotalOpenedMailCount, 
                        COUNT(CASE IdDeliveryStatus 
                                WHEN 100 THEN 1 
                              END) DistinctOpenedMailCount, 
                        MAX(Date)  LastOpenedEmailDate 
                 FROM   dbo.CampaignDeliveriesOpenInfo CDU WITH(NOLOCK) 
                 GROUP  BY CDU.IdCampaign) OPENS 
             ON c.IdCampaign = OPENS.IdCampaign 
           LEFT JOIN (SELECT L.IdCampaign, 
                             SUM(ISNULL(LT.Count, 0))   TotalClickedMailCount, 
                             COUNT(ISNULL(LT.Count, 0)) DistinctClickedMailCount, 
                             MAX([Date])                LastClickedEmailDate 
                      FROM   dbo.Link L WITH(NOLOCK) 
                             JOIN dbo.LinkTracking LT WITH(NOLOCK) 
                               ON L.IdLink = LT.IdLink 
                      GROUP  BY L.IdCampaign) CLT 
                  ON OPENS.IdCampaign = CLT.IdCampaign 
           LEFT JOIN (SELECT F.IdCampaign, 
                             COUNT(ForwardID) ForwardedEmailsCount 
                      FROM   dbo.ForwardFriend F WITH(NOLOCK) 
                      GROUP  BY F.IdCampaign) F 
                  ON OPENS.IdCampaign = F.IdCampaign 
           LEFT JOIN (SELECT s.IdCampaign, 
                             COUNT(s.IdSubscriber) UnsubscriptionsCount 
                      FROM   dbo.Subscriber s WITH(NOLOCK) 
                      GROUP  BY s.IdCampaign) S 
                  ON OPENS.IdCampaign = S.IdCampaign 
    GROUP  by c.Name, 
              c.ContentType, 
              c.CampaignType, 
              C.IdTestAB
GO
PRINT N'Altering [dbo].[Campaigns_CampaignsForReportDetails_GX]...';


GO

ALTER PROCEDURE [dbo].[Campaigns_CampaignsForReportDetails_GX] @IdCampaign INT, 
                                                               @Status     INT 
AS 
    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   GetTestABSet(@IdCampaign); 

    SELECT result.Name, 
           MAX(result.Subject)                 Subject, 
           result.ContentType, 
           SUM(result.DistinctOpenedMailCount) DistinctOpenedMailCount, 
           SUM(result.SoftBouncedMailCount)    SoftBouncedMailCount, 
           SUM(result.HardBouncedMailCount)    HardBouncedMailCount, 
           SUM(result.UnopenedMailCount)       UnopenedMailCount, 
           MIN(result.UTCSentDate)             UTCSentDate, 
           result.CampaignType, 
           result.IsTestAB, 
           result.SamplingPercentage, 
           result.TestABType 
    FROM   (SELECT C.Name, 
                   C.[Subject], 
                   C.ContentType, 
                   DistinctOpenedMailCount, 
                   SoftBouncedMailCount, 
                   HardBouncedMailCount, 
                   UnopenedMailCount, 
                   C.UTCSentDate, 
                   C.CampaignType, 
                   CAST(ISNULL(C.IdTestAB, 0) as BIT) as IsTestAB, 
                   ISNULL(Test.SamplingPercentage, 0) as SamplingPercentage, 
                   ISNULL(Test.TestType, 0)           as TestABType 
            FROM   @t t1 
                   JOIN Campaign C 
                     ON T1.IdCampaign = C.IdCampaign 
                   LEFT JOIN(SELECT c.IdCampaign, 
                                    COUNT(CASE IdDeliveryStatus 
                                            WHEN 0 THEN 0 
                                          END) UnopenedMailCount, 
                                    COUNT(CASE IdDeliveryStatus 
                                            WHEN 2 THEN 2 
                                            WHEN 8 THEN 2 
                                          END) HardBouncedMailCount, 
                                    COUNT(CASE IdDeliveryStatus 
                                            WHEN 1 THEN 1 
                                            WHEN 3 THEN 1 
                                            WHEN 4 THEN 1 
                                            WHEN 5 THEN 1 
                                            WHEN 6 THEN 1 
                                            WHEN 7 THEN 1 
                                          END) SoftBouncedMailCount, 
                                    COUNT(CASE IdDeliveryStatus 
                                            WHEN 100 THEN [COUNT] 
                                          END) DistinctOpenedMailCount 
                             FROM   CampaignDeliveriesOpenInfo c WITH(NOLOCK) 
                             GROUP  BY c.IdCampaign)t 
                          ON t1.IdCampaign = t.IdCampaign 
                   LEFT JOIN TestAB Test 
                          ON Test.IdTestAB = C.IdTestAB) as result 
    GROUP  BY result.Name, 
              result.ContentType, 
              result.CampaignType, 
              result.IsTestAB, 
              result.SamplingPercentage, 
              result.TestABType
GO
PRINT N'Altering [dbo].[Campaigns_CampaignsSentPageByClient_GX]...';


GO
ALTER PROCEDURE [dbo].[Campaigns_CampaignsSentPageByClient_GX] @IdUser        INT, 
                                                               @PageNumber    INT, 
                                                               @AmountPerPage INT 
AS 
    DECLARE @CGCP_GX TABLE 
      ( 
         Nro        INT IDENTITY, 
         IDCampaign INT, 
         IdStatus   INT 
      ) 
    DECLARE @CGCP_GX_Res TABLE 
      ( 
         IdCampaign              INT, 
         [Name]                  VARCHAR(100), 
         UTCSentDate             DATETIME, 
         [Subject]               NVARCHAR(100), 
         IdCampaignType          INT, 
         DistinctOpenedMailCount INT, 
         HardBouncedMailCount    INT, 
         SoftBouncedMailCount    INT, 
         UnopenedMailCount       INT, 
         IDStatus                INT, 
         SocialSharedStatus      BIT, 
         StringType              VARCHAR(50), 
         IsTestAB                BIT, 
         SamplingPercentage      INT, 
         TestABType              INT, 
         HasReplicated           TINYINT	 
      ) 
    DECLARE @IdCampaign INT; 
    DECLARE @IdStatus INT; 
    DECLARE cur CURSOR FOR 
      WITH UserCampaigns 
           AS (SELECT ROW_NUMBER() 
                        OVER( 
                          ORDER BY cp.UTCSentDate DESC) AS Nro, 
                      CP.IdCampaign, 
                      CP.Status 
               FROM   Campaign CP WITH(NOLOCK) 
               WHERE  CP.IdUser = @IdUser 
                      AND CP.Active = 1 
                      AND CP.Status IN ( 5, 6, 9 ) 
                      AND ( CP.TestABCategory = 3 
                             OR CP.TestABCategory IS NULL )) 
      SELECT IdCampaign, 
             Status 
      FROM   UserCampaigns 
      WHERE  Nro BETWEEN ( @PageNumber - 1 ) * @AmountPerPage + 1 AND @PageNumber * @AmountPerPage;

    OPEN CUR 

    FETCH NEXT FROM CUR INTO @IdCampaign, @IdStatus 

    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    WHILE @@FETCH_STATUS = 0 
      BEGIN 
          DELETE FROM @t 

          INSERT INTO @t 
          SELECT IdCampaign 
          FROM   GetTestABSet(@IdCampaign) 

          INSERT INTO @CGCP_GX_Res 
          SELECT C.IdCampaign, 
                 C.[Name], 
                 c.UTCSentDate, 
                 C.[Subject], 
                 [dbo].[CampaignTypeToInt](c.CampaignType, ContentType), 
                 DistinctOpenedMailCount, 
                 HardBouncedMailCount, 
                 SoftBouncedMailCount, 
                 UnopenedMailCount, 
                 C.Status, 
                 C .EnabledShareSocialNetwork, 
                 C.CampaignType, 
                 CAST(ISNULL(C.IdTestAB, 0) AS BIT) AS IsTestAB, 
                 ISNULL(T.SamplingPercentage, 0)    AS SamplingPercentage, 
                 ISNULL(T.TestType, 0)              AS TestABType, 
                 CASE 
                   WHEN EXISTS (SELECT TOP 1 IdCampaign 
                                FROM   dbo.Campaign CS 
                                WHERE  CS.IdParentCampaign = c.IdCampaign 
                                       AND cs.Active = 1 
                                       AND cs.Status NOT IN ( 5, 6, 9, 1 )) THEN 2 -- exists replicated campaign scheduled or sending
                   WHEN EXISTS (SELECT TOP 1 IdCampaign 
                                FROM   dbo.Campaign CS 
                                WHERE  CS.IdParentCampaign = c.IdCampaign 
                                       AND cs.Active = 1 
                                       AND cs.Status = 1 ) THEN 1 -- exists replicated campaign in draft
                   ELSE 0 
                 END                                HasReplicated 
          FROM   DBO.Campaign c WITH(NOLOCK) 
                 LEFT JOIN (SELECT @IdCampaign AS IdCampaign, 
                                   COUNT(CASE IdDeliveryStatus 
                                           WHEN 0 THEN 0 
                                         END)  UnopenedMailCount, 
                                   COUNT(CASE IdDeliveryStatus 
                                           WHEN 2 THEN 2 
                                           WHEN 8 THEN 2 
                                         END)  HardBouncedMailCount, 
                                   COUNT(CASE IdDeliveryStatus 
                                           WHEN 1 THEN 1 
                                           WHEN 3 THEN 1 
                                           WHEN 4 THEN 1 
                                           WHEN 5 THEN 1 
                                           WHEN 6 THEN 1 
                                           WHEN 7 THEN 1 
                                         END)  SoftBouncedMailCount, 
                                   SUM(CASE IdDeliveryStatus 
                                         WHEN 100 THEN 1 
                                       END)    DistinctOpenedMailCount 
                            FROM   @t t 
                                   JOIN CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
                                     ON t.IdCampaign = cdoi.IdCampaign) OPENS 
                        ON C.IdCampaign = OPENS.IdCampaign 
                 LEFT JOIN TestAB T 
                        ON T.IdTestAB = C.IdTestAB 
          WHERE  C.IdCampaign = @IdCampaign 

          FETCH NEXT FROM CUR INTO @IdCampaign, @IdStatus 
      END 

    CLOSE CUR 

    DEALLOCATE CUR 

    SELECT IdCampaign, 
           [Name], 
           UTCSentDate, 
           [Subject], 
           IdCampaignType, 
           DistinctOpenedMailCount, 
           HardBouncedMailCount, 
           SoftBouncedMailCount, 
           UnopenedMailCount, 
           IdStatus, 
           SocialSharedStatus, 
           StringType, 
           IsTestAB, 
           SamplingPercentage, 
           TestABType,
           HasReplicated
    FROM   @CGCP_GX_Res 
    ORDER  BY UTCSentDate DESC
GO
