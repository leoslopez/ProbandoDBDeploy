CREATE VIEW [dbo].[OldUserInternalSettings]
AS
SELECT     
	ClientID, 
	AccountSuspended, 
	AccountCancelled, 
	CancelledDate
FROM 
	Doppler.dbo.ClientInternalSettings