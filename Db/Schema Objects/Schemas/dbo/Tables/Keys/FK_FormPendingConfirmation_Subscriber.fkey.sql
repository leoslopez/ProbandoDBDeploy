ALTER TABLE [dbo].[FormPendingConfirmation]
    ADD CONSTRAINT [FK_FormPendingConfirmation_Subscriber] FOREIGN KEY ([IdSubcriber]) REFERENCES [dbo].[Subscriber] ([IdSubscriber]) ON DELETE NO ACTION ON UPDATE NO ACTION;

