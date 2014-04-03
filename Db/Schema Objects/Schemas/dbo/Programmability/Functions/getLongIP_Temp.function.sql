CREATE FUNCTION [dbo].[getLongIP_Temp] 
( 
    @ip NVARCHAR(MAX)    
)
RETURNS BIGINT
BEGIN 
    DECLARE @start INT, @end INT, @part INT
    DECLARE @result BIGINT
    
    SELECT @start = 1, @end = CHARINDEX('.', @ip), @part = 1
    SET @result = 0
    
    WHILE @start < LEN(@ip) + 1 
    BEGIN 
        IF @end = 0  
            SET @end = LEN(@ip) + 1
       
		IF @part = 1
			SET @result = @result + CONVERT(BIGINT,SUBSTRING(@ip, @start, @end - @start)) * 16777216
		IF @part = 2
			SET @result = @result + CONVERT(BIGINT,SUBSTRING(@ip, @start, @end - @start)) * 65536
        IF @part = 3
			SET @result = @result + CONVERT(BIGINT,SUBSTRING(@ip, @start, @end - @start)) * 256
		IF @part = 4
			SET @result = @result + CONVERT(BIGINT,SUBSTRING(@ip, @start, @end - @start))
        
        SET @start = @end + 1 
        SET @end = CHARINDEX('.', @ip, @start)
        
        SET @part = @part + 1
        
    END 
    
    RETURN @result
END