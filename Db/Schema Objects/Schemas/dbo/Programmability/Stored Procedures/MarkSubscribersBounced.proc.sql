
CREATE PROCEDURE [dbo].[MarkSubscribersBounced]
AS
BEGIN
declare @Date datetime
set @Date=convert(datetime,convert(varchar(10),GETDATE(),101),101)
set @date=DATEADD(dd,-2,@Date)

declare @IdSubscriber bigint
-- Recorro bounced
DECLARE Bounced CURSOR FOR
select distinct IdSubscriber
FROM subscriber s WITH (NOLOCK)
WHERE s.IdSubscribersStatus in (5,8)
and s.UTCUnsubDate>@date

OPEN Bounced
FETCH NEXT FROM Bounced
INTO @IdSubscriber

WHILE @@FETCH_STATUS =0
BEGIN
BEGIN TRY
UPDATE SubscriberXList WITH(ROWLOCK)
SET Active=0
WHERE IdSubscriber=@IdSubscriber 
END TRY
BEGIN CATCH
SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH

FETCH NEXT FROM Bounced
INTO @IdSubscriber

END

CLOSE Bounced
DEALLOCATE Bounced


END