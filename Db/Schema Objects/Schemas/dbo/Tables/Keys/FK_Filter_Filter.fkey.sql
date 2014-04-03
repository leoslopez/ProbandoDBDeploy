ALTER TABLE [dbo].[Filter]
    ADD CONSTRAINT [FK_Filter_Filter] FOREIGN KEY ([ParentFilter]) REFERENCES [dbo].[Filter] ([IdFilter]) ON DELETE NO ACTION ON UPDATE NO ACTION;




GO
/*ALTER TABLE [dbo].[Filter] NOCHECK CONSTRAINT [FK_Filter_Filter];*/

