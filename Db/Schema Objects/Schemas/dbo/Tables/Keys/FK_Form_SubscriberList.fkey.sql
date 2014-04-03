ALTER TABLE [dbo].[Form]
    ADD CONSTRAINT [FK_Form_SubscriberList] FOREIGN KEY ([IdSubscribersList]) REFERENCES [dbo].[SubscribersList] ([IdSubscribersList]) ON DELETE NO ACTION ON UPDATE NO ACTION;

