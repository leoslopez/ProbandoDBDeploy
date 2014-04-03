ALTER TABLE [dbo].[MovementsCredits]
    ADD CONSTRAINT [FK_MovementsCredits_Admin] FOREIGN KEY ([IdAdmin]) REFERENCES [dbo].[Admin] ([IdAdmin]) ON DELETE NO ACTION ON UPDATE NO ACTION;

