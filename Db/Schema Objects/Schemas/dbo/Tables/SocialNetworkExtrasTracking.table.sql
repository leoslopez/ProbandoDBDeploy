CREATE TABLE [dbo].[SocialNetworkExtrasTracking] (
    [IdSocialNetworkExtrasTracking] INT      IDENTITY (1, 1) NOT NULL,
    [IdSubscriber]                  INT      NULL,
    [IdSocialNetworkExtras]         INT      NOT NULL,
    [IdCampaign]                    INT      NOT NULL,
    [Count]                         INT      NOT NULL,
    [Date]                          DATETIME NOT NULL
) ON [Campaign];



