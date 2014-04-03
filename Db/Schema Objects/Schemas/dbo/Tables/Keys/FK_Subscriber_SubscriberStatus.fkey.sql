ALTER TABLE [dbo].[Subscriber]
    ADD CONSTRAINT [FK_Subscriber_SubscriberStatus] FOREIGN KEY ([IdSubscribersStatus]) REFERENCES [dbo].[SubscriberStatus] ([IdSubscriberStatus]) ON DELETE NO ACTION ON UPDATE NO ACTION;

