/****** Object:  StoredProcedure [dbo].[Security_ClientLanguage_UP]    Script Date: 08/07/2013 11:39:24 ******/

CREATE PROCEDURE [dbo].[Security_ClientLanguage_UP]
@IdUser int, 
@IdLanguage     INT 
AS 
    UPDATE [dbo].[User] WITH(ROWLOCK) 
    SET IdLanguage = @IdLanguage
	WHERE @IdUser = @IdUser