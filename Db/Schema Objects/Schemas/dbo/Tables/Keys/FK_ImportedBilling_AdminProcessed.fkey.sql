ALTER TABLE [dbo].[ImportedBilling]
    ADD CONSTRAINT [FK_ImportedBilling_AdminProcessed] FOREIGN KEY ([IdAdminProcessing]) REFERENCES [dbo].[Admin] ([IdAdmin]) ON DELETE NO ACTION ON UPDATE NO ACTION;



