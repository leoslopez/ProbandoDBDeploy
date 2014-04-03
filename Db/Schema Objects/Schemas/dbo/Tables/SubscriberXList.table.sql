CREATE TABLE [dbo].[SubscriberXList] (
    [IdSubscribersList] INT      NOT NULL,
    [IdSubscriber]      INT      NOT NULL,
    [Active]            BIT      NOT NULL,
    [UTCDeleteDate]     DATETIME NULL
)