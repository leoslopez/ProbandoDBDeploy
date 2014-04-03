
CREATE PROCEDURE [dbo].[MarkSubscribersFromBlackList]
AS
BEGIN
	DECLARE @Table TABLE (IdSubscriber INT, Email varchar(250))


	INSERT INTO @Table (IdSubscriber, Email)
	SELECT TOP 1000000 s.IdSubscriber, s.Email 
	FROM dbo.Subscriber s
	WHERE s.IdSubscribersStatus = 5 AND s.IdUnsubscriptionReason IS NULL

	UPDATE Dbo.Subscriber 
		SET IdUnsubscriptionReason = (CASE	
										WHEN Ble.Email IS NOT NULL  OR bld.Domain IS NOT NULL THEN 1
									    ELSE 3
									  END)
	FROM dbo.Subscriber s WITH(NOLOCK)
	JOIN @Table T on T.IdSubscriber = s.IdSubscriber
	LEFT JOIN dbo.BlackListEmail ble WITH(NOLOCK) on T.Email = ble.Email
	LEFT JOIN dbo.BlackListDomain bld WITH(NOLOCK) on T.Email like bld.Domain


END