ALTER TABLE [dbo].[Subscriber]
    ADD CONSTRAINT [FK_Subscriber_SubscriberSourceType] FOREIGN KEY ([IdSubscriberSourceType]) REFERENCES [dbo].[SubscriberSourceType] ([IdSubscriberSourceType]) ON DELETE NO ACTION ON UPDATE NO ACTION;

