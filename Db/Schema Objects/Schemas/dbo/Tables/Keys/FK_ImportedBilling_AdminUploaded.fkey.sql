ALTER TABLE [dbo].[ImportedBilling]
    ADD CONSTRAINT [FK_ImportedBilling_AdminUploaded] FOREIGN KEY ([IdAdminUploaded]) REFERENCES [dbo].[Admin] ([IdAdmin]) ON DELETE NO ACTION ON UPDATE NO ACTION;



