CREATE PROCEDURE [dbo].[Subscribers_SubscriberByApertureDate_GX]
@IdCampaign INT,
@ApertureDate DATETIME
AS

    SET @ApertureDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), @ApertureDate, 101)) 

    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   Gettestabset(@IdCampaign) 

    SELECT S.IdSubscriber, 
           S.FirstName, 
           S.LastName, 
           S.IdCountry 
    FROM   @t t 
           INNER JOIN dbo.CampaignDeliveriesOpenInfo CDOI WITH(NOLOCK) 
                   on t.IdCampaign = CDOI.IdCampaign 
           join dbo.Subscriber S WITH(NOLOCK) 
             ON S.IdSubscriber = CDOI.IdSubscriber 
    WHERE  CDOI.IdDeliveryStatus = 100 
           AND CONVERT(VARCHAR(10), CDOI.[Date], 101) = @ApertureDate 