CREATE PROCEDURE [dbo].[Report_AccountsActivity] @BeginDate Datetime, 
                                                 @EndDate   Datetime 
AS 
    SELECT * 
    FROM   (SELECT COUNT(u.iduser) 'NewAccountsRangeYear', 
                   COUNT(case 
                           WHEN u.UTCRegisterDate >= @BeginDate 
                                and u.UTCRegisterDate <= @EndDate THEN 1 
                           else null 
                         END)      'NewAccountsRange', 
                   COUNT(case 
                           WHEN MONTH(u.UTCRegisterDate) >= Month(@BeginDate) 
                                and MONTH(u.UTCRegisterDate) <= Month(@EndDate) THEN 1 
                           else null 
                         END)      as 'New AccountsRangeMonth' 
            FROM   dbo.[User] u 
            where  YEAR(u.UTCRegisterDate) BETWEEN YEAR(@BeginDate) and YEAR(@EndDate) 
            GROUP  BY YEAR(u.UTCRegisterDate)) NewAccounts, 
           (select COUNT(bc.IdUser) 'UpgradeToIndividualRangeYear', 
                   COUNT(case 
                           WHEN bc.Date >= @BeginDate 
                                and bc.Date <= @EndDate THEN 1 
                           ELSE null 
                         end)       AS 'UpgradeToIndividualRange', 
                   COUNT(case 
                           WHEN Month(bc.Date) >= Month(@BeginDate) 
                                and Month(bc.Date) <= Month(@EndDate) THEN 1 
                           ELSE null 
                         end)       AS 'UpgradeToIndividualRangeMonth' 
            from   dbo.BillingCredits bc 
                   JOIN dbo.UserTypesPlans utp 
                     on bc.IdUserTypePlan = utp.IdUserTypePlan 
            where  YEAR(bc.Date) BETWEEN YEAR(@BeginDate) and YEAR(@EndDate) 
                   and bc.IdBillingCreditType IN ( 1, 4 ) 
                   and utp.IdUserType = 3 
            GROUP  BY YEAR(bc.Date)) UpgradeToIndividual, 
           (select COUNT(bc.IdUser) 'UpgradeToMensualRangeYear', 
                   COUNT(case 
                           WHEN Convert(datetime, bc.Date) >= @BeginDate 
                                and Convert(datetime, bc.Date) <= @EndDate THEN 1 
                           ELSE null 
                         end)       AS 'UpgradeToMensualRange', 
                   COUNT(case 
                           WHEN Month(bc.Date) >= Month(@BeginDate) 
                                and Month(bc.Date) <= Month(@EndDate) THEN 1 
                           ELSE null 
                         end)       AS 'UpgradeToMensualRangeMonth' 
            from   dbo.BillingCredits bc 
                   JOIN dbo.UserTypesPlans utp 
                     on bc.IdUserTypePlan = utp.IdUserTypePlan 
            where  YEAR(bc.Date) BETWEEN YEAR(@BeginDate) and YEAR(@EndDate) 
                   and bc.IdBillingCreditType IN ( 1, 5 ) 
                   and utp.IdUserType = 2 
            GROUP  BY YEAR(bc.Date)) UpgradeToMensual, 
           (select COUNT(bc.IdUser) 'UpgradeToBySubscriberRangeYear', 
                   COUNT(case 
                           WHEN bc.Date >= @BeginDate 
                                and bc.Date <= @EndDate THEN 1 
                           ELSE null 
                         end)       as 'UpgradeToBySubscriberRange', 
                   COUNT(case 
                           WHEN Month(bc.Date) >= Month(@BeginDate) 
                                and Month(bc.Date) <= Month(@EndDate) THEN 1 
                           ELSE null 
                         end)       as 'UpgradeToBySubscriberRangeMonth' 
            from   dbo.BillingCredits bc 
                   JOIN dbo.UserTypesPlans utp 
                     on bc.IdUserTypePlan = utp.IdUserTypePlan 
            where  YEAR(bc.Date) BETWEEN YEAR(@BeginDate) and YEAR(@EndDate) 
                   and bc.IdBillingCreditType IN ( 1, 6 ) 
                   and utp.IdUserType = 4 
            GROUP  BY YEAR(bc.Date)) UpgradeToBySubscriber