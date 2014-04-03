ALTER TABLE [dbo].[UserChangesHistory]
    ADD CONSTRAINT [FK_UserChangesHistory_Admin] FOREIGN KEY ([IdAdmin]) REFERENCES [dbo].[Admin] ([IdAdmin]) ON DELETE NO ACTION ON UPDATE NO ACTION;

