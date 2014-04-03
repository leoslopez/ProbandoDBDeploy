/****** Object:  StoredProcedure [dbo].[CampaignQueuedStatus_UP]    Script Date: 08/07/2013 10:06:37 ******/

CREATE PROCEDURE [dbo].[CampaignQueuedStatus_UP] 
AS 
    DECLARE @IdCampaign int 
    DECLARE @LanguageID int 
    DECLARE @date datetime 
    DECLARE @IdSubscriber bigint 
    DECLARE @cant int 

    SET @date=getUTCdate() 

    declare Camp_LISTS cursor for 
      SELECT distinct c.IdCampaign 
      from   dbo.Campaign c WITH(NOLOCK) 
             JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
               ON c.IdCampaign = cdoi.IdCampaign 
      WHERE  c.status = 10 
             and ( cdoi.IdDeliveryStatus = 100 
                   AND cdoi.date <= DATEADD(hh, -6, GETDATE()) ) 

    open Camp_LISTS 

    fetch next from Camp_LISTS into @IdCampaign 

    while @@fetch_status = 0 
      begin 
         
        -- Aqui se debe poner la actualizacion   
        -- de envio y cobro (subscribers)  
        EXECUTE Common_CampaignCredits_UP @IdCampaign

          fetch next from Camp_LISTS into @IdCampaign 
      end 

    close Camp_LISTS 

    deallocate Camp_LISTS 

    IF EXISTS(SELECT 1 
              FROM   Campaign WITH(ROWLOCK) 
              WHERE  IdCampaign = @IdCampaign 
                     and IdUser in ( 17373, 12790 )) 
      BEGIN 
          INSERT INTO [CampaignFieldUsed] 
          SELECT distinct cdoi.IDcampaign, 
                          cdoi.IdSubscriber, 
                          cxf.IdField, 
                          fxs.Value 
          FROM   dbo.Campaign c WITH(NOLOCK) 
                 JOIN dbo.CampaignDeliveriesOpenInfo cdoi WITH(NOLOCK) 
                   ON c.IdCampaign = cdoi.IdCampaign 
                 JOIN ContentXField cxf WITH(NOLOCK) 
                   on c.IdContent = cxf.IdContent 
                 JOIN dbo.FieldXSubscriber fxs WITH(NOLOCK) 
                   ON cdoi.IdSubscriber = fxs.IdSubscriber 
                      AND cxf.IdField = fxs.IdField 
          WHERE  c.IDcampaign = @IdCampaign 
      END 

GO 