/****** Object:  StoredProcedure [dbo].[StatisticsDaily_Add]    Script Date: 08/07/2013 11:41:08 ******/


CREATE PROCEDURE [dbo].[StatisticsDaily_Add] @EmailsQtyByDay    bigint, 
                                             @CampaignsQtyByDay bigint, 
                                             @date              datetime 
AS 
    INSERT INTO [Statistics] 
                (EmailsQtyByDay, 
                 CampaignsQtyByDay, 
                 date) 
    VALUES      (@EmailsQtyByDay, 
                 @CampaignsQtyByDay, 
                 @date) 

    SELECT SCOPE_IDENTITY() 

GO 