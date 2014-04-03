ALTER TABLE [dbo].[SubscriberXList]
    ADD CONSTRAINT [FK_SubscriberXList_Suscriber] FOREIGN KEY ([IdSubscriber]) REFERENCES [dbo].[Subscriber] ([IdSubscriber]) ON DELETE NO ACTION ON UPDATE NO ACTION;

