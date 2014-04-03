CREATE TABLE [dbo].[CampaignDeliveriesSocialOpenInfo] (
    [IdCampaignDeliveriesSocialOpenInfo] INT          IDENTITY (1, 1) NOT NULL,
    [IdCampaign]                         INT          NOT NULL,
    [IdSocialNetwork]                    INT          NOT NULL,
    [IdSubscriber]                       INT          NULL,
    [IpAddress]                          VARCHAR (50) NULL,
    [LocId]                              INT          NULL,
    [IdPlatform]                         INT          NULL,
    [IdUserMailAgent]                    INT          NULL,
    [Count]                              INT          NOT NULL,
    [Date]                               DATETIME     NOT NULL
) ON [Campaign];





