CREATE TABLE [dbo].[SocialNetworkAutoPublishXUser] (
    [IdUser]          INT           NOT NULL,
    [IdSocialNetwork] INT           NOT NULL,
    [Active]          BIT           NULL,
    [AccessToken]     VARCHAR (250) NULL,
    [SecretToken]     VARCHAR (250) NULL,
    [Username]        VARCHAR (100) NULL
);











