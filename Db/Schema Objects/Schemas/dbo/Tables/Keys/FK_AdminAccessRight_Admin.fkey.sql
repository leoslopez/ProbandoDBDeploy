ALTER TABLE [dbo].[AdminAccessRight]
    ADD CONSTRAINT [FK_AdminAccessRight_Admin] FOREIGN KEY ([IdAdmin]) REFERENCES [dbo].[Admin] ([IdAdmin]) ON DELETE NO ACTION ON UPDATE NO ACTION;

