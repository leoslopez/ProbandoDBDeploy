ALTER TABLE [dbo].[TestAB]
    ADD CONSTRAINT [FK_TestAB_TestCriteria] FOREIGN KEY ([IdCriteria]) REFERENCES [dbo].[TestCriteria] ([IdCriteria]) ON DELETE NO ACTION ON UPDATE NO ACTION;

