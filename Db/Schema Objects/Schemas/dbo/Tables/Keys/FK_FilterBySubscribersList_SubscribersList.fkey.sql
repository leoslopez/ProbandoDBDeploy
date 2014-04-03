ALTER TABLE [dbo].[FilterBySubscribersList]
    ADD CONSTRAINT [FK_FilterBySubscribersList_SubscribersList] FOREIGN KEY ([IdSubscribersLists]) REFERENCES [dbo].[SubscribersList] ([IdSubscribersList]) ON DELETE CASCADE ON UPDATE NO ACTION;

