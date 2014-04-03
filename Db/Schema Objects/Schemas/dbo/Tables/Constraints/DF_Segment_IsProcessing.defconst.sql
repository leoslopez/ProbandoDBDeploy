ALTER TABLE [dbo].[Segment]
    ADD CONSTRAINT [DF_Segment_IsProcessing] DEFAULT ((0)) FOR [IsProcessing];

