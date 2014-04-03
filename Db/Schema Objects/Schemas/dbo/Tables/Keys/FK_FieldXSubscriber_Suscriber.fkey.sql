ALTER TABLE [dbo].[FieldXSubscriber]
    ADD CONSTRAINT [FK_FieldXSubscriber_Suscriber] FOREIGN KEY ([IdSubscriber]) REFERENCES [dbo].[Subscriber] ([IdSubscriber]) ON DELETE NO ACTION ON UPDATE NO ACTION;

