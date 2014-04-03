CREATE PROCEDURE [dbo].[ClientCustomFieldsByCampaignID_SubscriberId_GX] 
@IdCampaign   int, 
@IdSubscriber bigint 
AS 
SET NOCOUNT ON

SELECT f.IdField, 
isnull(fxs.IdSubscriber, @IdSubscriber) SubscriberID, 
f.Name, 
f.IdField, 
CASE 
WHEN ( f.DataType = 0 AND fxs.Value = 'True' ) THEN 'Verdadero' 
WHEN ( f.DataType = 0 AND fxs.Value = 'False' ) THEN 'Falso' 
WHEN f.DataType = 1 THEN REPLACE(REPLACE(CONVERT(varchar, fxs.value), ',', ''), '.', ',') 
WHEN f.DataType = 3 THEN SUBSTRING(CONVERT(varchar, fxs.value, 120), 4, 3) 
+ SUBSTRING(CONVERT(varchar, fxs.value, 120), 1, 3) + SUBSTRING(CONVERT(varchar, fxs.value, 120), 7, 4) 
ELSE fxs.value end Value, 
f.Active 
FROM Campaign c WITH(NOLOCK) 
JOIN [User] u WITH(NOLOCK) 
ON u.IdUser = c.IdUser 
JOIN dbo.ContentXField cxf WITH(NOLOCK) 
ON c.IdCampaign = cxf.IdContent 
JOIN Field f WITH(NOLOCK) 
ON f.IdField = cxf.IdField 
LEFT JOIN dbo.FieldXSubscriber fxs 
ON f.IdField = fxs.IdField AND fxs.IdSubscriber = @IdSubscriber 
WHERE f.Active = 1 AND u.IdLanguage = 1 
UNION 
SELECT f.IdField, 
isnull(fxs.IdSubscriber, @IdSubscriber) SubscriberID, 
f.Name, 
f.IdField, 
fxs.value, 
f.Active 
FROM Campaign c WITH(NOLOCK) 
JOIN [User] u WITH(NOLOCK) 
ON u.IdUser = c.IdUser 
JOIN dbo.ContentXField cxf WITH(NOLOCK) 
ON c.IdCampaign = cxf.IdContent 
JOIN Field f WITH(NOLOCK) 
ON f.IdField = cxf.IdField 
LEFT JOIN dbo.FieldXSubscriber fxs 
ON f.IdField = fxs.IdField AND fxs.IdSubscriber = @IdSubscriber 
WHERE f.Active = 1 AND u.IdLanguage = 2 

GO 