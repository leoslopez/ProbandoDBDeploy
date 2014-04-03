-- =============================================
-- Script Template
-- =============================================
CREATE PROCEDURE [dbo].[UpdateDomainKeyInformation]  
 @ClientID int,  -- User to update  
 @AbuseEmail nvarchar(50) = NULL,
 @City varchar(256) = NULL,
 @Domain nvarchar(50) = NULL,
 @Active bit,
 @OrgName nvarchar(50) = NULL,
 @OrgUnit nvarchar(50) = NULL,
 @PersonEmail nvarchar(50) = NULL,
 @ResponsiblePerson nvarchar(50) = NULL,
 @PublicKey  varchar(700) = NULL,
 @Date datetime,
 @Approved bit,    -- This parameter is used to update the field 'DomainKeyRequestStatus'
 @CountryCode nvarchar(255) = NULL,
 @State nvarchar(255) = NULL
AS  

declare @countryId int, @stateId int 

SET @countryId = (SELECT TOP 1 IdCountry FROM [Country] C WITH(NOLOCK)
			WHERE C.Code = @CountryCode)

SET @stateId = (SELECT TOP 1 IdState FROM [State] S WITH(NOLOCK)
			WHERE UPPER(S.Name) LIKE UPPER(@State) AND S.CountryCode = @CountryCode)
BEGIN  
SET NOCOUNT ON  
--MERGE DomainKeyInformation AS [Target] 
--USING (SELECT 1) AS [Source]  
--ON ([Target].IdUser = @IdUser)  
--WHEN MATCHED THEN  
 UPDATE [Target]
 SET [Target].AbuseEmail =   
 CASE   
  WHEN (ISNULL(LTRIM(RTRIM(@AbuseEmail)),'') = '') THEN [Target].AbuseEmail
  ELSE @AbuseEmail  
 END,
 [Target].City =   
 CASE   
  WHEN (ISNULL(LTRIM(RTRIM(@City)),'') = '') THEN [Target].City
  ELSE @City  
 END,
 [Target].Domain =   
 CASE   
  WHEN (ISNULL(LTRIM(RTRIM(@Domain)),'') = '') THEN [Target].Domain
  ELSE @Domain 
 END,
 [Target].IsDomainKeyActive =  @Active,
 [Target].OrganizationName =   
 CASE   
  WHEN (ISNULL(LTRIM(RTRIM(@OrgName)),'') = '') THEN [Target].OrganizationName
  ELSE @OrgName 
 END,
 [Target].OrganizationUnit =   
 CASE   
  WHEN (ISNULL(LTRIM(RTRIM(@OrgUnit)),'') = '') THEN [Target].OrganizationUnit
  ELSE @OrgUnit 
 END,
 [Target].PersonEmail =   
 CASE   
  WHEN (ISNULL(LTRIM(RTRIM(@PersonEmail)),'') = '') THEN [Target].PersonEmail
  ELSE @PersonEmail 
 END,
 [Target].ResponsiblePerson =   
 CASE   
  WHEN (ISNULL(LTRIM(RTRIM(@ResponsiblePerson)),'') = '') THEN [Target].ResponsiblePerson
  ELSE @ResponsiblePerson 
 END,
 [Target].PublicKey =   
 CASE   
  WHEN (ISNULL(LTRIM(RTRIM(@PublicKey)),'') = '') THEN [Target].PublicKey
  ELSE @PublicKey 
 END,
 [Target].Date =   
 CASE   
  WHEN (ISNULL(@Date,'') = '') THEN [Target].Date
  ELSE @Date 
 END,
 [Target].DomainKeyRequestStatus =   
 CASE   
  WHEN (@Approved = 1) THEN 2  --approved
  WHEN (@Approved = 0) THEN 1  --pending
  ELSE [Target].DomainKeyRequestStatus  
 END,
 [Target].IdCountry = 
 CASE   
  WHEN (ISNULL(LTRIM(RTRIM(@CountryCode)),'') = '') THEN [Target].IdCountry
  WHEN (ISNULL(@countryId,'') = '') THEN [Target].IdCountry
  ELSE @countryId  
 END,
 [Target].IdState = 
 CASE   
  WHEN (ISNULL(LTRIM(RTRIM(@State)),'') = '') THEN [Target].IdState
  WHEN (ISNULL(@stateId,'') = '') THEN [Target].IdState
  ELSE @stateId  
 END
 FROM DomainKeyInformation [Target] WHERE [Target].IdUser = @ClientID
END
