CREATE VIEW [dbo].[OldUserTypesPlans]
AS 
SELECT
    ClientTypeID IdUserType,
    ClientTypePlanID IdUserTypePlan,
    Description as Description
FROM
    Doppler.dbo.ClientTypesPlans