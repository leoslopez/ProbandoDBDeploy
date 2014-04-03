ALTER TABLE [dbo].[AccountingEntry]
    ADD CONSTRAINT [FK_AccountingEntry_SourceTypes] FOREIGN KEY ([Source]) REFERENCES [dbo].[SourceTypes] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

