ALTER TABLE [dbo].[LinkTracking]
    ADD CONSTRAINT [FK_LinkTracking_Subscriber] FOREIGN KEY ([IdSubscriber]) REFERENCES [dbo].[Subscriber] ([IdSubscriber]) ON DELETE NO ACTION ON UPDATE NO ACTION;

