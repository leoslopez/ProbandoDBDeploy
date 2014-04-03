CREATE TABLE [dbo].[SocialNetworkAutoPublishXCampaign] (
    [IdCampaign]      INT            NOT NULL,
    [IdSocialNetwork] INT            NOT NULL,
    [Active]          BIT            NULL,
    [Username]        NVARCHAR (100) NULL,
    [AccessToken]     NVARCHAR (250) NULL,
    [SecretToken]     NVARCHAR (250) NULL
);





















