/****** Object:  StoredProcedure [dbo].[SubscribersByLanguage_Normal_GX]    Script Date: 08/07/2013 11:44:48 ******/

CREATE PROCEDURE [dbo].[SubscribersByLanguage_Normal_GX] @Idcampaign int, 
                                                       @IDLanguage int 
AS 
    SELECT DISTINCT S.IdSubscriber, 
                    S.FirstName, 
                    S.LastName, 
                    S.Email, 
                    S.IdSubscribersStatus, 
                    S.IdUser, 
                    0 LanguageID 
    FROM   dbo.SubscribersListXCampaign slxc WITH (NOLOCK) 
           JOIN dbo.SubscriberXList sxl WITH (NOLOCK) 
             ON slxc.IdSubscribersList = sxl.IdSubscribersList 
           JOIN Subscriber s WITH (NOLOCK) 
             ON s.IdSubscriber = sxl.IdSubscriber 
    WHERE  ( slxc.Idcampaign = @Idcampaign ) 
           and ( S.IdSubscribersStatus < 3 ) 
           AND ( sxl.Active = 1 ) 
           AND ( ( S.email NOT like '%@hotmail%' ) 
                  OR ( S.email NOT like '%@msn%' ) 
                  OR ( S.email NOT like '%@live%' ) 
                  OR ( S.email NOT like '%@cantv%' )
				  OR ( S.email NOT like '%@outlook%' )  ) 

GO 