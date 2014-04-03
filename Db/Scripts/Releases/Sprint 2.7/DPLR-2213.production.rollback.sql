ALTER PROCEDURE [dbo].[Scan_Available_Subscribers]
AS 
/* Hard Bounced 2,8 */ 
/* Soft Bounced 1,3,4,5,6,7 */ 
/* Not Open 0 */ 
declare @Date datetime 
declare @Date_down datetime 
declare @Date_up datetime 
set @Date=convert(datetime,convert(varchar(10),GETDATE(),101),101) 
declare @flag int 
declare @SB int 
declare @HB int 
declare @NO int 

declare @ContentType int 
declare @IdSubscriber bigint 
declare @ConsecutiveHardBounced int 
declare @HardBounceLimit int 
declare @ConsecutiveSoftBounced int 
declare @SoftBounceLimit int 
declare @ConsecutiveUnopendedEmails int 
declare @NeverOpenLimit int 
declare @CampaignID int 
declare @IdDeliveryStatus int 
declare @sql varchar(max) 
declare @temp_CampDelive table( 
IdCampaign int, 
[date] datetime) 

set @date_down=DATEADD(dd,-1,@Date) 
set @date_up=@Date 
print(@date_down) 
print(@date_up) 

set @SB=0 
set @HB=0 
set @NO=0 

CREATE TABLE #DeleteSubscribers(
[IdSubscriber] [bigint] NOT NULL,
 CONSTRAINT [PK_DeleteSubscribers] PRIMARY KEY NONCLUSTERED 
(
[IdSubscriber] ASC
 )
 ) 
-- Recorro Opens y Actualizo Subscribers 
DECLARE Opens CURSOR FOR 
select distinct c.IdSubscriber 
FROM dbo.CampaignDeliveriesOpenInfo c WITH (NOLOCK) 
WHERE c.[date] between @date_down and @date_up 
AND c.IdDeliveryStatus=100 

OPEN Opens 
FETCH NEXT FROM Opens 
INTO @IdSubscriber 
WHILE @@FETCH_STATUS =0 
BEGIN 
BEGIN TRY 
UPDATE Subscriber WITH(ROWLOCK) 
SET IdSubscribersStatus=1, UTCUnsubDate=null, 
ConsecutiveHardBounced=0,ConsecutiveSoftBounced=0,ConsecutiveUnopendedEmails=0 
WHERE IdSubscriber=@IdSubscriber AND IdSubscribersStatus NOT in (5,8) 

INSERT INTO #DeleteSubscribers 
SELECT @IdSubscriber
 END TRY 
BEGIN CATCH 
SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage; 
END CATCH 
FETCH NEXT FROM Opens 
INTO @IdSubscriber 
END 

CLOSE Opens 
DEALLOCATE Opens 

--Recorro envios y Actualizo contadores 
INSERT INTO @temp_CampDelive 
SELECT c.IdCampaign, c.UTCSentDate 
FROM Campaign c 
WHERE (c.UTCSentDate between @date_down and @date_up) 
and c.Status=5 

DECLARE Subsc CURSOR FOR 
select distinct s.IdSubscriber, 
case cdoi.IdDeliveryStatus
 WHEN 0 THEN 0 
WHEN 1 THEN 1 
WHEN 2 THEN 2 
WHEN 3 THEN 1 
WHEN 4 THEN 1 
WHEN 5 THEN 1 
WHEN 6 THEN 1 
WHEN 7 THEN 1 
WHEN 8 THEN 2 
END as IdDeliveryStatus, 
ISNULL(s.ConsecutiveHardBounced,0), u.ConsecutiveHardBounced as HardBounceLimit, 
ISNULL(s.ConsecutiveSoftBounced,0), u.ConsecutiveSoftBounced as SoftBounceLimit, 
ISNULL(s.ConsecutiveUnopendedEmails,0), u.ConsecutiveUnopendedEmails as NeverOpenLimit, 
cam.ContentType 
from dbo.Subscriber s WITH (NOLOCK) 
join dbo.[User] u WITH (NOLOCK) 
on s.idUser=u.idUser
 join dbo.CampaignDeliveriesOpenInfo cdoi WITH (NOLOCK) 
ON cdoi.IdSubscriber=s.IdSubscriber
 JOIN Campaign cam WITH (NOLOCK) 
ON cam.IdCampaign=cdoi.IdCampaign AND cam.idUser=s.idUser
 join @temp_CampDelive x 
on cdoi.IdCampaign=x.IdCampaign 
WHERE s.IdSubscriber NOT IN (select IdSubscriber FROM #DeleteSubscribers) 
AND s.IdSubscribersStatus<3 AND u.ConsecutiveHardBounced is NOT null 
AND u.ConsecutiveSoftBounced is NOT null AND u.ConsecutiveUnopendedEmails is NOT null 
AND cdoi.IdDeliveryStatus between 0 and 8 
order by case cdoi.IdDeliveryStatus
 WHEN 0 THEN 0 
WHEN 1 THEN 1 
WHEN 2 THEN 2 
WHEN 3 THEN 1 
WHEN 4 THEN 1 
WHEN 5 THEN 1 
WHEN 6 THEN 1 
WHEN 7 THEN 1 
WHEN 8 THEN 2 
END desc 

OPEN Subsc 
FETCH NEXT FROM Subsc 
INTO @IdSubscriber, @IdDeliveryStatus,@ConsecutiveHardBounced,@HardBounceLimit, 
@ConsecutiveSoftBounced,@SoftBounceLimit,@ConsecutiveUnopendedEmails,@NeverOpenLimit, 
@ContentType 

WHILE @@FETCH_STATUS =0 
BEGIN 

if (@IdDeliveryStatus=2) -- HARD 
BEGIN 
if (@ConsecutiveHardBounced+1>=@HardBounceLimit) 
BEGIN 
BEGIN TRY 
UPDATE Subscriber WITH (ROWLOCK) 
SET ConsecutiveHardBounced=@ConsecutiveHardBounced +1, 
UTCUnsubDate=@date, IdSubscribersStatus=3 
WHERE IdSubscriber=@IdSubscriber 
END TRY 
BEGIN CATCH 
SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage; 
END CATCH 
END 
ELSE 
UPDATE Subscriber WITH (ROWLOCK) 
SET ConsecutiveHardBounced=@ConsecutiveHardBounced +1 
WHERE IdSubscriber=@IdSubscriber 
END 
ELSE 
if (@IdDeliveryStatus=1) -- SOFT 
BEGIN 
if (@ConsecutiveSoftBounced+1>=@SoftBounceLimit) 
BEGIN 
BEGIN TRY 
UPDATE Subscriber WITH (ROWLOCK) 
SET ConsecutiveSoftBounced=@ConsecutiveSoftBounced +1, 
UTCUnsubDate=@date, IdSubscribersStatus=4 
WHERE IdSubscriber=@IdSubscriber 
END TRY 
BEGIN CATCH 
SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage; 
END CATCH 
END 
ELSE 
UPDATE Subscriber WITH (ROWLOCK) 
SET ConsecutiveSoftBounced=@ConsecutiveSoftBounced +1, 
ConsecutiveHardBounced=0 
WHERE IdSubscriber=@IdSubscriber 
END 
ELSE 
if (@IdDeliveryStatus=0 AND @ContentType<>1) 
BEGIN 
if (@ConsecutiveUnopendedEmails+1>=@NeverOpenLimit) 
BEGIN 
BEGIN TRY 
UPDATE Subscriber WITH (ROWLOCK) 
SET ConsecutiveUnopendedEmails=@ConsecutiveUnopendedEmails +1, 
UTCUnsubDate=@date, IdSubscribersStatus=6 
WHERE IdSubscriber=@IdSubscriber 
END TRY 
BEGIN CATCH 
ROLLBACK TRAN 
SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage; 
END CATCH 
END 
ELSE 
UPDATE Subscriber WITH (ROWLOCK) 
SET ConsecutiveUnopendedEmails =@ConsecutiveUnopendedEmails +1, 
ConsecutiveHardBounced=0, ConsecutiveSoftBounced=0 
WHERE IdSubscriber=@IdSubscriber 
END 
ELSE 
if (@IdDeliveryStatus=0 AND @ContentType=1 AND (@ConsecutiveHardBounced>0 OR @ConsecutiveSoftBounced>0)) 
BEGIN 
--print(@IdSubscriber) 
UPDATE Subscriber WITH (ROWLOCK) 
SET ConsecutiveHardBounced=0, ConsecutiveSoftBounced=0 
WHERE IdSubscriber=@IdSubscriber 
END 

FETCH NEXT FROM Subsc 
INTO @IdSubscriber, @IdDeliveryStatus,@ConsecutiveHardBounced,@HardBounceLimit, 
@ConsecutiveSoftBounced,@SoftBounceLimit,@ConsecutiveUnopendedEmails,@NeverOpenLimit, 
@ContentType 
END 

CLOSE Subsc 
DEALLOCATE Subsc 

DROP TABLE #DeleteSubscribers