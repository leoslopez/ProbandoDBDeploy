CREATE PROCEDURE [dbo].[GetCountryByIPnumber]
 @IpNumber bigint  -- IP number from the IP address of the subscriber
AS

BEGIN
	SELECT TOP 1 c.IdCountry, c.Name, c.DialingCode FROM Blocks b WITH(NOLOCK)
		INNER JOIN Location l WITH(NOLOCK) ON(b.LocId = l.LocId)
		INNER JOIN Country c WITH(NOLOCK) ON(l.Country = c.Code)
	WHERE @IpNumber BETWEEN StartIpNum AND EndIpNum
END

/*** SCRIPT TO UPDATE USERS WHO STARTED THE REGISTRATION USING OLD WORKFLOW AND WILL TRY FINISH USING THE NEW WORKFLOW ***/