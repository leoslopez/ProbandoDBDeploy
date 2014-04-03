CREATE TABLE [dbo].[SubscribersList] (
    [IdSubscribersList]     INT           IDENTITY (500000, 1) NOT NULL,
    [IdUser]                INT           NOT NULL,
    [IdLabel]               INT           NULL,
    [SubscribersListStatus] INT           NOT NULL,
    [Name]                  VARCHAR (100) NOT NULL,
    [Active]                BIT           NOT NULL,
    [UTCCreationDate]       DATETIME      NULL,
    [UTCLastUseDate]        DATETIME      NULL,
    [Ranking]               INT           NULL,
    [APIKey]                VARCHAR (100) NULL,
    [Visible]               BIT           NOT NULL,
    [UTCDeleteDate]         DATETIME      NULL,
    [UTCLastSentDate]       DATETIME      NULL
) ON [SubscriberList];

