/****** Object:  StoredProcedure [dbo].[Security_Client_G]    Script Date: 08/07/2013 11:39:05 ******/

CREATE PROCEDURE [dbo].[Security_Client_G]
@EMail VARCHAR(100),
@PasswordHash VARCHAR(32)
AS
SELECT
u.IdUser ,
u.FirstName,
u.LastName,
0 PermissionType,
u.IdLanguage,
L.Name,
ISNULL(L.Name,'') + '-' + CO.Code Locale,
ut.IdUserType,
0
FROM [User] u WITH(NOLOCK)
LEFT JOIN [Language] L WITH(NOLOCK)
ON u.IdLanguage = L.IdLanguage
LEFT JOIN [State] s WITH(NOLOCK)
ON u.IdState=s.IdState
LEFT JOIN Country CO WITH(NOLOCK)
ON s.IdCountry = CO.IdCountry
LEFT JOIN BillingCredits bc WITH(NOLOCK)
ON u.IdCurrentBillingCredit=bc.IdBillingCredit
LEFT JOIN UserTypesPlans utp WITH(NOLOCK)
ON utp.IdUserTypePlan=bc.IdUserTypePlan
LEFT JOIN UserTypes ut WITH(NOLOCK)
ON ut.IdUserType=utp.IdUserType
WHERE u.Email = @EMail AND u.[Password] = @PasswordHash