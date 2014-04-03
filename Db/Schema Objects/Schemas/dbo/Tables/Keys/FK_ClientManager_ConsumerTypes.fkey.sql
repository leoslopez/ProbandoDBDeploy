ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_ConsumerTypes] FOREIGN KEY ([IdConsumerType]) REFERENCES [dbo].[ConsumerTypes] ([IdConsumerType]) ON DELETE NO ACTION ON UPDATE NO ACTION;



