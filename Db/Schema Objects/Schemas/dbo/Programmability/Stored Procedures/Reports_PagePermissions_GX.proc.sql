/****** Object:  StoredProcedure [dbo].[Reports_PagePermissions_GX]    Script Date: 08/07/2013 11:38:40 ******/

CREATE PROCEDURE [dbo].[Reports_PagePermissions_GX]
@PageName varchar(250)
AS
BEGIN
	SELECT 0 as PermissionTypeID
	
	--SELECT PermissionTypeID  
	--FROM PagePermissions  WITH(NOLOCK)
	--WHERE PageName = @PageName   
END
GO