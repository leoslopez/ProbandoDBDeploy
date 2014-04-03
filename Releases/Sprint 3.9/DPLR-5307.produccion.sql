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