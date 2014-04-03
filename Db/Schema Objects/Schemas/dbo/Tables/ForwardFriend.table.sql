CREATE TABLE [dbo].[ForwardFriend] (
    [ForwardID]    INT           IDENTITY (1, 1) NOT NULL,
    [IdSubscriber] INT           NOT NULL,
    [IdCampaign]   INT           NOT NULL,
    [FirstName]    VARCHAR (100) NOT NULL,
    [LastName]     VARCHAR (100) NOT NULL,
    [Email]        VARCHAR (100) NOT NULL,
    [Date]         DATETIME      NOT NULL
);



