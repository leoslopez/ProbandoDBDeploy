USE Doppler2011_Local;
UPDATE [dbo].[User]
SET MaxSubscribers = 500
WHERE MaxSubscribers IS NULL