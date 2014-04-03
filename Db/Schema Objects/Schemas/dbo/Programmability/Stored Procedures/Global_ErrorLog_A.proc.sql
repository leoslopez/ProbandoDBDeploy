

CREATE PROCEDURE [dbo].[Global_ErrorLog_A]
@Message varchar(2000),  
@URL varchar(500),  
@Browser varchar(250),  
@UserAgent varchar(250),  
@SourceModule varchar(250)  
AS  
SET NOCOUNT ON

INSERT INTO ErrorLog  WITH(ROWLOCK) ([TimeStamp], [Message], URL, Browser, UserAgent, SourceModule)
VALUES (GETDATE(), @Message, @URL, @Browser, @UserAgent, @SourceModule)  