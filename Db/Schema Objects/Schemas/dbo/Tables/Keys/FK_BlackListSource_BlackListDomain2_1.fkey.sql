ALTER TABLE [dbo].[BlackListDomain]
    ADD CONSTRAINT [FK_BlackListSource_BlackListDomain2] FOREIGN KEY ([IdSource]) REFERENCES [dbo].[BlackListSource] ([IdSource]) ON DELETE NO ACTION ON UPDATE NO ACTION;

