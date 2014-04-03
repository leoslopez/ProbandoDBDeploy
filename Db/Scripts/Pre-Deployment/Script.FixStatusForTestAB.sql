
BEGIN
	UPDATE [dbo].[Campaign] set [Status] = 16 where [Status] = 11
	UPDATE [dbo].[Campaign] set [Status] = 15 where [Status] = 10
	UPDATE [dbo].[Campaign] set [Status] = 14 where [Status] = 9
	UPDATE [dbo].[Campaign] set [Status] = 13 where [Status] = 8
	UPDATE [dbo].[Campaign] set [Status] = 12 where [Status] = 7
	UPDATE [dbo].[Campaign] set [Status] = 11 where [Status] = 6
	UPDATE [dbo].[Campaign] set [Status] = 10 where [Status] = 2
	UPDATE [dbo].[Campaign] set [Status] = 10 where [Status] = 3
	UPDATE [dbo].[Campaign] set [Status] = 8 where [Status] = 5
	UPDATE [dbo].[Campaign] set [Status] = 5 where [Status] = 4
	UPDATE [dbo].[Campaign] set [Status] = 4 where [Status] = 1
	UPDATE [dbo].[Campaign] set [Status] = 1 where [Status] = 0
END

