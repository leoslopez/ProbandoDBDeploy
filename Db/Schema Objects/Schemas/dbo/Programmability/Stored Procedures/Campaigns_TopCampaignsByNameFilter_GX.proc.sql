CREATE PROCEDURE [dbo].[Campaigns_TopCampaignsByNameFilter_GX] @IDUser INT, 
                                                               @Top    INT, 
                                                               @Filter VARCHAR(100) 
AS 
    SET NOCOUNT ON 

    DECLARE @CGCP_GX TABLE 
      ( 
         IdCampaign  INT, 
         [Status]    INT, 
         UTCSentDate DATETIME 
      ) 
    DECLARE @GTABS TABLE 
      ( 
         IdCampaign INT 
      ) 
    DECLARE @IDCampaign INT 
    DECLARE @Status INT 

    SET ROWCOUNT @Top 

    INSERT INTO @CGCP_GX 
                (IdCampaign, 
                 [Status], 
                 UTCSentDate) 
    SELECT C.IdCampaign, 
           C.Status, 
           ISNULL(C.UTCSentDate, '2012-11-01') AS SentDate 
    FROM   Campaign C WITH(NOLOCK) 
    WHERE  C.IdUser = @IDUser 
           AND c.Active = 1 
           AND [Status] IN ( 5, 6, 9 ) 
           AND ( [Name] LIKE @Filter 
                  OR [Subject] LIKE @Filter ) 
    ORDER  BY UTCSentDate DESC 

    INSERT INTO @GTABS 
    SELECT [dbo].[GetIdCampaignTestAB](t.IdCampaign) AS IdCampaign 
    FROM   @CGCP_GX t 

    SELECT C.IdCampaign, 
           C.[Name], 
           ISNULL(c.UTCSentDate, '2012-11-01 00:00:00') AS UTCSentDate, 
           C.[Subject], 
           C.CampaignType, 
           t1.DistinctOpenedMailCount, 
           t1.HardBouncedMailCount, 
           t1.SoftBouncedMailCount, 
           t1.UnopenedMailCount, 
           C.Status, 
           C.CampaignType, 
           CAST(ISNULL(C.IdTestAB, 0) AS BIT)           AS IsTestAB 
    FROM   dbo.Campaign c WITH(NOLOCK) 
           JOIN @CGCP_GX t 
             ON C.IdCampaign = t.IdCampaign 
           LEFT JOIN (SELECT cdoi.IdCampaign, 
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
                                   WHEN 100 THEN 1 
                                 END)   DistinctOpenedMailCount 
                      FROM   CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
                      GROUP  BY cdoi.IdCampaign) t1 
                  ON c.IdCampaign = t1.IdCampaign 
    WHERE  ( C.TestABCategory = 3 
              OR C.TestABCategory IS NULL ) 
    ORDER  BY UTCSentDate DESC 

GO 