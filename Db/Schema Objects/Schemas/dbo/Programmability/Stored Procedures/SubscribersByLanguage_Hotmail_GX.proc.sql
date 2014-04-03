/****** Object:  StoredProcedure [dbo].[SubscribersByLanguage_Hotmail_GX]    Script Date: 08/07/2013 11:44:41 ******/

CREATE PROCEDURE [dbo].[SubscribersByLanguage_Hotmail_GX] @Idcampaign int, 
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
           AND ( ( S.email like '%@hotmail%' ) 
                  OR ( S.email like '%@msn%' ) 
                  OR ( S.email like '%@outlook%' ) 
                  OR ( S.email like '%@live%' ) ) 

GO 