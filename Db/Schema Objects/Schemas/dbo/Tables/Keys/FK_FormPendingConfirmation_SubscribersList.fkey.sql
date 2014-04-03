ALTER TABLE [dbo].[FormPendingConfirmation]
    ADD CONSTRAINT [FK_FormPendingConfirmation_SubscribersList] FOREIGN KEY ([IdSubcribersList]) REFERENCES [dbo].[SubscribersList] ([IdSubscribersList]) ON DELETE NO ACTION ON UPDATE NO ACTION;

