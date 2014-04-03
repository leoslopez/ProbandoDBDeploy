ALTER TABLE [dbo].[Segment]
    ADD CONSTRAINT [FK_Segment_SegmentType] FOREIGN KEY ([IdSegmentType]) REFERENCES [dbo].[SegmentType] ([IdSegmentType]) ON DELETE NO ACTION ON UPDATE NO ACTION;

