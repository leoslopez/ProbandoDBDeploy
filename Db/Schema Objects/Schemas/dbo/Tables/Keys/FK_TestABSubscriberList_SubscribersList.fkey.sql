ALTER TABLE [dbo].[TestABSubscriberList]
    ADD CONSTRAINT [FK_TestABSubscriberList_SubscribersList] FOREIGN KEY ([IdSubscriberList]) REFERENCES [dbo].[SubscribersList] ([IdSubscribersList]) ON DELETE CASCADE ON UPDATE NO ACTION;



