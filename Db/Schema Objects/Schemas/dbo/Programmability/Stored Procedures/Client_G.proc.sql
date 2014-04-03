CREATE PROCEDURE [dbo].[Client_G] 
@IDUser int 
AS 
SET NOCOUNT ON
		SELECT u.IdUser, 
			   FirstName, 
			   LastName, 
			   Address, 
			   '', 
			   PhoneNumber, 
			   '', 
			   Company, 
			   Email, 
			   CityName, 
			   u.IdState, 
			   ZipCode, 
			   '', 
			   Email, 
			   [Password], 
			   1, 
			   IdIndustry, 
			   u.CCNumber, 
			   u.CCExpMonth, 
			   u.CCExpYear, 
			   u.CCHolderFullName, 
			   u.IDCCType, 
			   s.IdCountry, 
			   IdUserTimeZone, 
			   u.CCVerification, 
			   0, 
			   bc.IdUserTypePlan, 
			   0, 
			   Promotioncode, 
			   BillingFirstName, 
			   BillingLastName, 
			   BillingPhone, 
			   BillingFax, 
			   BillingAddress, 
			   BillingCity, 
			   IDBillingState, 
			   BillingZip, 
			   b.IdCountry, 
			   AllowContact, 
			   NonProfitOrganization, 
			   0, 
			   UTCRegisterDate, 
			   0, 
			   IdLanguage, 
			   0, 
			   PaymentMethod, 
			   APIKey, 
			   0, 
			   d.Domain, 
			   0, 
			   0, 
			   0, 
			   '', 
			   '', 
			   IdAmountMonthlyEmails, 
			   AccountValidation, 
			   website, 
			   0, 
			   0, 
			   PasswordResetCodeDate 
		FROM   [User] u WITH(NOLOCK) 
			   LEFT JOIN [BillingCredits] bc WITH(NOLOCK) 
					  ON bc.IdBillingCredit = u.IdCurrentBillingCredit 
			   LEFT JOIN [State] s WITH(NOLOCK) 
					  ON s.IdState = u.IdState 
			   LEFT JOIN [State] b WITH(NOLOCK) 
					  ON b.IdState = u.IdBillingState 
			   LEFT JOIN DomainKeyInformation d WITH(NOLOCK) 
					  ON u.IdUser = d.IdUser AND d.IsDomainKeyActive = 1
		WHERE  u.IdUser = @IDUser 

GO 