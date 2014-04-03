CREATE PROCEDURE [dbo].[DomainKeysToGenerateCertificate]
AS
BEGIN
	SELECT 
	  [IdUser]
	  ,C.Code
	  ,S.Name
	  ,[City]
      ,[OrganizationName]
      ,[OrganizationUnit]
      ,[ResponsiblePerson]
      ,[PersonEmail]
      ,[Domain]
	FROM DomainKeyInformation DKI
	INNER JOIN Country C on DKI.IdCountry = C.IdCountry
	INNER JOIN [dbo].[State] S on DKI.IdState = S.IdState
	WHERE DomainKeyRequestStatus = 3
END