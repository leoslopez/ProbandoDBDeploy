CREATE PROCEDURE [dbo].[Campaigns_CampaignSummaryByIDAndFilter_GX] 
@IdCampaign      INT,   
@IdStatus        INT,   
@emailFilter     VARCHAR(50),  
@firstnameFilter VARCHAR(50),  
@lastnameFilter  VARCHAR(50)  
AS   
DECLARE @CCSbyIDF_GX TABLE (IdCampaign INT )   
  
    INSERT INTO @CCSbyIDF_GX   
    SELECT IdCampaign   
    FROM   GetTestABSet(@IdCampaign)   
  
    SELECT SUM(CASE IdDeliveryStatus   
                 WHEN 100 THEN 1   
               END)   DistinctOpenedMailCount,   
           COUNT(CASE IdDeliveryStatus   
                   WHEN 1 THEN 1   
                   WHEN 3 THEN 1   
                   WHEN 4 THEN 1   
                   WHEN 5 THEN 1   
                   WHEN 6 THEN 1   
                   WHEN 7 THEN 1   
                 END) SoftBouncedMailCount,   
           COUNT(CASE IdDeliveryStatus   
                   WHEN 2 THEN 2   
                   WHEN 8 THEN 2   
                 END) HardBouncedMailCount,   
           COUNT(CASE IdDeliveryStatus   
                   WHEN 0 THEN 0   
                 END) UnopenedMailCount   
    FROM   @CCSbyIDF_GX t   
           JOIN DBO.CampaignDeliveriesOpenInfo c WITH(NOLOCK)   
             ON t.IdCampaign = c.IdCampaign   
           JOIN Subscriber s WITH(NOLOCK, INDEX(PK_Suscriber))   
             ON c.IdSubscriber = s.IdSubscriber   
    WHERE  s.email LIKE @emailFilter   
           AND ISNULL(s.Firstname, '') LIKE @firstnameFilter   
           AND ISNULL(s.lastname, '') LIKE @lastnameFilter   
    GROUP  BY t.IdCampaign 

GO 