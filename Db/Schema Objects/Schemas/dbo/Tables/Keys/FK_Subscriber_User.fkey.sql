ALTER TABLE [dbo].[Subscriber]
    ADD CONSTRAINT [FK_Subscriber_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;

