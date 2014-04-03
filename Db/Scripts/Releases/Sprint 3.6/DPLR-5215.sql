update dbo.[User] 
SET PaymentMethod = 4
where PaymentMethod is null
GO

ALTER TABLE dbo.[User] ALTER COLUMN [PaymentMethod] INTEGER NOT NULL 
GO
ALTER TABLE dbo.[User] ADD CONSTRAINT DF_User_PaymentMethod DEFAULT 4 FOR [PaymentMethod]