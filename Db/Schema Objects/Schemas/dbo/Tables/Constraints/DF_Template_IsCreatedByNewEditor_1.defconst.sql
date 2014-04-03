ALTER TABLE [dbo].[Template]
    ADD CONSTRAINT [DF_Template_IsCreatedByNewEditor] DEFAULT ((0)) FOR [IsCreatedByNewEditor];

