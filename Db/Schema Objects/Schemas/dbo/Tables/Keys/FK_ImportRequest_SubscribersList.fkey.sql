ALTER TABLE [dbo].[ImportRequest]
    ADD CONSTRAINT [FK_ImportRequest_SubscribersList] FOREIGN KEY ([IdSubscriberList]) REFERENCES [dbo].[SubscribersList] ([IdSubscribersList]) ON DELETE NO ACTION ON UPDATE NO ACTION;

