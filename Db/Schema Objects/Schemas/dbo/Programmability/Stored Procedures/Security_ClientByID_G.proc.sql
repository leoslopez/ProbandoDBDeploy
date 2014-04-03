/****** Object:  StoredProcedure [dbo].[Security_ClientByID_G]    Script Date: 08/07/2013 11:39:18 ******/

CREATE PROCEDURE [dbo].[Security_ClientByID_G]
@IdUser int  
AS  
SELECT u.EMail,  
       u.[Password],  
       u.FirstName,  
       u.LastName,  
       0 PermissionType,  
       u.IdLanguage,
       L.Name,  
       ISNULL(L.Name,'') Locale,  
       ut.IdUserType,  
       0,  
       u.email,  
       v.Fullname,  
       u.Company,  
       u.PhoneNumber,  
       '' AS VendorName,  
       u.Address,  
       u.ZipCode,  
       u.CityName,  
       utz.Offset,  
       isnull(u.AmountAttemps,0) InvalidLoginAttemps,  
       0 ValidLoginAttemps,  
       0  
FROM   [User] u WITH(NOLOCK)  
JOIN   dbo.Language L WITH(NOLOCK)  
  ON   u.IdLanguage = L.IdLanguage  
JOIN BillingCredits bc WITH(NOLOCK)
ON u.IdCurrentBillingCredit=bc.IdBillingCredit 
JOIN UserTypesPlans utp WITH(NOLOCK)
ON utp.IdUserTypePlan=bc.IdUserTypePlan 
JOIN UserTypes ut WITH(NOLOCK)
ON ut.IdUserType=utp.IdUserType 
JOIN dbo.UserTimeZone utz WITH(NOLOCK)
ON u.IdUserTimeZone=utz.IdUserTimeZone 
JOIN dbo.Vendor v WITH(NOLOCK)
ON v.IdVendor=u.IdVendor 
WHERE  u.IdUser=@IdUser
GO