
CREATE PROCEDURE [dbo].[ExportsGire] @IdUser INT, @DaysAmount INT
AS 
    DECLARE @date DATETIME 

	SET @date=dateadd(dd, -@DaysAmount, GETDATE()) --'2011-03-04'        
    --PRINT( @date ) 

    SELECT 
    --ca.name,             
    s.email, 
    f.Name Description, 
    CASE 
      WHEN c.IdDeliveryStatus = 0 THEN 'No abierto' 
      WHEN c.IdDeliveryStatus = 100 THEN 'Abierto' 
      WHEN c.IdDeliveryStatus IN (2,8) THEN 'Hard' 
      ELSE 'Soft' 
    END estado, 
    CASE 
      WHEN c.IdDeliveryStatus = 0 THEN 'Enviado correctamente' 
      WHEN c.IdDeliveryStatus = 100 THEN 'Abierto' 
      WHEN c.IdDeliveryStatus = 1 THEN 'Host Invalido' 
      WHEN c.IdDeliveryStatus = 2 THEN 'EMail Rechazado' 
      WHEN c.IdDeliveryStatus = 3 THEN 'TimeOut' 
      WHEN c.IdDeliveryStatus = 4 THEN 'Error de Transaccion' 
      WHEN c.IdDeliveryStatus = 5 THEN 'Server Rechazado' 
      WHEN c.IdDeliveryStatus = 6 THEN 'EMail Rechazado (Casilla llena, etc.)' 
      WHEN c.IdDeliveryStatus = 7 THEN 'MX record no encontrado' 
      WHEN c.IdDeliveryStatus = 8 THEN 'Formato de EMail inválido' 
      ELSE 'Not Sent' 
    END descrestado, 
    substring(CONVERT(VARCHAR, c.date, 120), 9, 2) 
    + '/' 
    + substring(CONVERT(VARCHAR, c.date, 120), 6, 2) 
    + '/' 
    + substring(CONVERT(VARCHAR, c.date, 120), 1, 4) 
    + substring(CONVERT(VARCHAR, c.date, 120), 11, 10), 
    u.Value Data 
    FROM   Campaign ca 
           JOIN dbo.CampaignFieldUsed u 
             ON ca.IdCampaign = u.IdCampaign 
           JOIN dbo.Field f 
             ON u.IdField = f.IdField 
           JOIN (SELECT c.IdCampaign, 
                        c.IdSubscriber, 
                        c.IdDeliveryStatus, 
                        c.date 
                 FROM   dbo.CampaignDeliveriesOpenInfo c 
                 WHERE  c.Date > @date)c 
             ON u.IdCampaign = c.IdCampaign 
                AND u.IdSubscriber = c.IdSubscriber 
           JOIN Subscriber s 
             ON u.IdSubscriber = s.IdSubscriber 
    WHERE  ca.IdUser = @IdUser 
           AND c.Date > @date 
    ORDER  BY c.IdCampaign, 
              s.Email, 
              f.Name