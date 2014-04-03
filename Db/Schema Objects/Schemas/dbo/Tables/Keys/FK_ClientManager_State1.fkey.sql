ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_State1] FOREIGN KEY ([IdBillingState]) REFERENCES [dbo].[State] ([IdState]) ON DELETE NO ACTION ON UPDATE NO ACTION;

