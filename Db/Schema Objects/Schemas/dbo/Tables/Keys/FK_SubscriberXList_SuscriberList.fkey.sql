ALTER TABLE [dbo].[SubscriberXList]
    ADD CONSTRAINT [FK_SubscriberXList_SuscriberList] FOREIGN KEY ([IdSubscribersList]) REFERENCES [dbo].[SubscribersList] ([IdSubscribersList]) ON DELETE CASCADE ON UPDATE NO ACTION;



