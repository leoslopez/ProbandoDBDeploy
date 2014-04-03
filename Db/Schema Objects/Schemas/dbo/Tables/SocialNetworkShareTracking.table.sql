CREATE TABLE [dbo].[SocialNetworkShareTracking] (
    [IdSocialNetworkShareTracking] INT      IDENTITY (1, 1) NOT NULL,
    [IdSubscriber]                 INT      NULL,
    [IdSocialNetwork]              INT      NOT NULL,
    [IdCampaign]                   INT      NOT NULL,
    [Count]                        INT      NOT NULL,
    [Date]                         DATETIME NOT NULL
) ON [Campaign];



