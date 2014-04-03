ALTER TABLE [dbo].[Label]
    ADD CONSTRAINT [DF_Label_LabelType] DEFAULT ('LIST') FOR [LabelType];

