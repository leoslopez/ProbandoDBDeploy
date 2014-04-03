-- =============================================
-- Script to fix ConsumerTypes Table
-- =============================================
DELETE FROM [dbo].[ConsumerTypes]
WHERE IdConsumerType = 5

UPDATE [dbo].[User]
SET IdConsumerType = 4, CUIT = '123'
WHERE IdConsumerType = 5

UPDATE [dbo].[BillingCredits]
SET IdConsumerType = 4, CUIT = '123'
WHERE IdConsumerType = 5

