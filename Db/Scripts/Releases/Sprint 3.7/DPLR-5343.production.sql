
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
         TestABType              INT 
      ) 
    DECLARE @IdCampaign INT 
    DECLARE @IdStatus INT 

    INSERT INTO @CGCP_GX 
                (IdCampaign, 
                 IdStatus) 
    SELECT CP.IdCampaign, 
           CP.Status 
    FROM   Campaign CP WITH(NOLOCK) 
    WHERE  CP.IdUser = @IdUser 
           AND CP.Active = 1 
           AND CP.Status IN ( 5, 6, 9 ) 
           AND ( CP.TestABCategory = 3 
                  OR CP.TestABCategory IS NULL ) 
    ORDER  BY CP.UTCSentDate DESC 

    DECLARE cur CURSOR FOR 
      SELECT IdCampaign, 
             IdStatus 
      FROM   @CGCP_GX 
      WHERE  Nro BETWEEN ( @PageNumber - 1 ) * @AmountPerPage + 1 AND @PageNumber * @AmountPerPage

    OPEN cur 

    FETCH NEXT FROM cur INTO @IdCampaign, @IdStatus 

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
                 C.EnabledShareSocialNetwork, 
                 C.CampaignType, 
                 CAST(ISNULL(C.IdTestAB, 0) as BIT) as IsTestAB, 
                 ISNULL(T.SamplingPercentage, 0)    as SamplingPercentage, 
                 ISNULL(T.TestType, 0)              as TestABType 
          FROM   dbo.Campaign c WITH(NOLOCK) 
                 LEFT JOIN (SELECT [dbo].[GetIdCampaignTestAB](cdoi.IdCampaign) as IdCampaign, 
                                   COUNT(CASE IdDeliveryStatus 
                                           WHEN 0 THEN 0 
                                         END)                                   UnopenedMailCount,
                                   COUNT(CASE IdDeliveryStatus 
                                           WHEN 2 THEN 2 
                                           WHEN 8 THEN 2 
                                         END)                                   HardBouncedMailCount,
                                   COUNT(CASE IdDeliveryStatus 
                                           WHEN 1 THEN 1 
                                           WHEN 3 THEN 1 
                                           WHEN 4 THEN 1 
                                           WHEN 5 THEN 1 
                                           WHEN 6 THEN 1 
                                           WHEN 7 THEN 1 
                                         END)                                   SoftBouncedMailCount,
                                   SUM(CASE IdDeliveryStatus 
                                         WHEN 100 THEN 1 
                                       END)                                     DistinctOpenedMailCount
                            FROM   (SELECT cdoi.IdCampaign, 
                                           cdoi.IdDeliveryStatus 
                                    FROM   @t t 
                                           JOIN CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
                                             on t.IdCampaign = cdoi.IdCampaign) cdoi 
                            GROUP  BY [dbo].[GetIdCampaignTestAB](cdoi.IdCampaign)) OPENS 
                        ON C.IdCampaign = OPENS.IdCampaign 
                 LEFT JOIN TestAB T 
                        ON T.IdTestAB = C.IdTestAB 
          WHERE  C.IdCampaign = @IdCampaign 

          FETCH NEXT FROM cur INTO @IdCampaign, @IdStatus 
      END 

    CLOSE cur 

    DEALLOCATE cur 

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
           TestABType 
    FROM   @CGCP_GX_Res 
    order  by UTCSentDate desc