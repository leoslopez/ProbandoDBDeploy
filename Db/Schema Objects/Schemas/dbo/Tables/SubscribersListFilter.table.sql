CREATE TABLE [dbo].[SubscribersListFilter] (
    [IdSubscribersListFilter] INT           IDENTITY (1, 1) NOT NULL,
    [IdSubscribersList]       INT           NULL,
    [IdSubscribersListSource] INT           NULL,
    [LeftCriteria]            VARCHAR (200) NOT NULL,
    [RightCriteria]           VARCHAR (200) NOT NULL,
    [Condition]               VARCHAR (50)  NOT NULL,
    [Active]                  BIT           NULL
) ON [SubscriberList];





