ALTER TABLE [dbo].[SubscribersList]
    ADD CONSTRAINT [DF_SubscribersList_SubscribersListStatus] DEFAULT ('1') FOR [SubscribersListStatus];

