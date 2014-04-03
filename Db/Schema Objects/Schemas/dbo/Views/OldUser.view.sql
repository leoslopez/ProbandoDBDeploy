CREATE VIEW [OldUser]
AS 
SELECT
    CL.ClientID as IdUser,
    Email,
    CCExpMonth,
    CCExpYear,
    CCHolderName,
    CCNumber,
    CCVerification,
    FirstName,
    LastName,
    BillingAddress,
    BillingCity,
    BillingFirstName,
    BillingLastName,
    BillingZip,    
	Password, 
	Active, 
	LoginAttempts, 
	SuccessfullyLogins,
    CTP.Description TypePlan,
    CO.Descripcion BillingCountryName,
    ST.Description BillingStateName,
	CIS.AccountCancelled AS IsCancelated, 
	CIS.BillingAgentID AS IdResponsabileBilling,
	PaymentMethod AS PaymentMethod
FROM
    Doppler.dbo.Clients CL LEFT JOIN 
    Doppler.dbo.Countries CO ON CL.BillingCountryID = CO.Id LEFT JOIN
    Doppler.dbo.States ST ON CL.BillingStateID = ST.StateID LEFT JOIN
    Doppler.dbo.ClientTypesPlans CTP ON CL.ClientTypePlanID = CTP.ClientTypePlanID LEFT OUTER JOIN
    Doppler.dbo.ClientInternalSettings AS CIS ON CL.ClientID = CIS.ClientID
