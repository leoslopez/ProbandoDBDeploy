/****** Object:  StoredProcedure [dbo].[Statistics_UserMailAgentsByCampaignAndFilter_GX]    Script Date: 08/07/2013 11:41:01 ******/


CREATE PROCEDURE [dbo].[Statistics_UserMailAgentsByCampaignAndFilter_GX] @IdCampaign      int,
                                                                        @EmailNameFilter varchar(50),
                                                                        @firstNameFilter varchar(50),
                                                                        @LastNameFilter  varchar(50)
AS 
  SET NOCOUNT ON 

  BEGIN TRY 
      SELECT IdUserMailAgent, 
             [IdPlatform], 
             Count(c.Count) 
      FROM   dbo.CampaignDeliveriesOpenInfo c WITH(NOLOCK) 
             JOIN Subscriber s WITH(NOLOCK) 
               on c.IdSubscriber = s.IdSubscriber 
      WHERE  c.IdCampaign = @IdCampaign 
             AND s.Email like @EmailNameFilter 
             AND ISNULL(s.Firstname, '') like @FirstNameFilter 
             AND ISNULL(s.lastname, '') like @LastNameFilter 
      GROUP  BY IdUserMailAgent, 
                [IdPlatform] 
  END TRY 

  BEGIN CATCH 
      print( 'error en Statistics_UserMailAgentsByCampaignAndFilter_GX' ) 
  END CATCH 