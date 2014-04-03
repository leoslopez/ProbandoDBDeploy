ALTER TABLE [dbo].[Segment]
    ADD CONSTRAINT [FK_Segment_Filter] FOREIGN KEY ([IdFilter]) REFERENCES [dbo].[Filter] ([IdFilter]) ON DELETE CASCADE ON UPDATE NO ACTION;

