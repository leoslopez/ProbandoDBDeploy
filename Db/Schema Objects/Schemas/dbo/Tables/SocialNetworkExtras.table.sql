CREATE TABLE [dbo].[SocialNetworkExtras] (
    [IdExtra]         INT          IDENTITY (1, 1) NOT NULL,
    [IdSocialNetwork] INT          NOT NULL,
    [Name]            VARCHAR (50) NULL,
    [Active]          BIT          NOT NULL
);





