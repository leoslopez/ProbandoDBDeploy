ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_ConsumerTypes] FOREIGN KEY ([IdConsumerType]) REFERENCES [dbo].[ConsumerTypes] ([IdConsumerType]) ON DELETE NO ACTION ON UPDATE NO ACTION;



