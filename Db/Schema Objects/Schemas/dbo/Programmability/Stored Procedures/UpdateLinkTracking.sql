/****** Object:  StoredProcedure [dbo].[UpdateLinkTracking]    Script Date: 08/07/2013 11:45:13 ******/

/*******************************************************************************************
Procedure:		UpdateLinkTracking
				(Copyright © 2012 Making Sense. All rights reserved.)
Purpose:		Register that a link of a campaign has been clicked by a subscriber.
Written by:		Esteban Asla
Tested on:		SQL Server 2008 R2
Date created:	August 28th 2012
*******************************************************************************************/
CREATE PROCEDURE [dbo].[UpdateLinkTracking]
	@IdSubscriber int,		-- Subscriber that opened the campaign
	@IdLink int,			-- The link that has been clicked
	@OpenDate datetime		-- Date and time when the link was clicked by subscriber
AS
BEGIN
SET NOCOUNT ON
-- If a record exists, increment a counter by one; otherwise, insert the record with a value of one. The following MERGE statement wraps this logic and uses the HOLDLOCK hint to avoid race conditions.
MERGE LinkTracking AS [Target]
USING (SELECT 1 AS One) AS [Source]
ON ([Target].IdLink = @IdLink AND [Target].IdSubscriber = @IdSubscriber)
WHEN MATCHED THEN
	UPDATE
	SET [Target].Count = [Target].Count + 1,
	[Target].Date = @OpenDate
WHEN NOT MATCHED THEN
	INSERT (IdLink, IdSubscriber, Count, Date)
	VALUES (@IdLink, @IdSubscriber, 1, @OpenDate);
END