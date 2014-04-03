CREATE TABLE [dbo].[SubscriberBlackList] (
    [IDSubscriber] BIGINT NULL,
    [Marked]       BIT    NULL,
    [MarkedDate]   DATE   NULL
) ON [Subscriber];

