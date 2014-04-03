-- =============================================
-- Script Template
-- =============================================
UPDATE  [dbo].[BillingCredits]
SET IdPaymentMethod = 1
WHERE IdPaymentMethod = 2

UPDATE  [dbo].[User]
SET PaymentMethod = 1
WHERE PaymentMethod = 2

DELETE FROM [dbo].[PaymentMethods]
WHERE IdPaymentMethod = 2;