CREATE PROCEDURE [dbo].[Admin_NewUsersByMonth]
AS

SELECT YEAR(u.UTCRegisterDate)  Year, 
       MONTH(u.utcregisterDate) Month, 
       COUNT(CASE 
               WHEN s.idCountry = 157 
                    AND u.AccountValidation = 1 THEN 1 
               ELSE NULL 
             END)               ActivatedInMexico, 
       COUNT(CASE 
               WHEN s.idCountry <> 157 
                    AND u.AccountValidation = 1 THEN 1 
               ELSE NULL 
             END)               ActivatedOutOfMexico, 
       COUNT(CASE 
               WHEN u.AmountUsedCompleteUserInfoLink >= 1 
                    AND u.AccountValidation = 0 THEN 1 
               ELSE NULL 
             END)               NotActiveWithClick, 
       COUNT(CASE 
               WHEN ( u.AmountUsedCompleteUserInfoLink = 0 
                       OR u.AmountUsedCompleteUserInfoLink IS NULL ) 
                    AND u.AccountValidation = 0 THEN 1 
               ELSE NULL 
             END)               NotActiveWithoutClick 
FROM   dbo.[User] u WITH(NOLOCK) 
       LEFT JOIN dbo.State s WITH(NOLOCK) 
              ON u.IdState = s.IdState 
WHERE  u.UTCRegisterDate IS NOT NULL 
GROUP  BY YEAR(u.UTCRegisterDate), 
          MONTH(u.utcregisterDate) 
ORDER  BY YEAR(u.UTCRegisterDate) DESC, 
          MONTH(u.utcregisterDate) DESC