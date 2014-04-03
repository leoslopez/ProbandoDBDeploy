ALTER TABLE [dbo].[MaxSubscribersToValidateHistory]
    ADD CONSTRAINT [FK_MaxSubscribersToValidateHistory_Admin] FOREIGN KEY ([IdAdmin]) REFERENCES [dbo].[Admin] ([IdAdmin]) ON DELETE NO ACTION ON UPDATE NO ACTION;

