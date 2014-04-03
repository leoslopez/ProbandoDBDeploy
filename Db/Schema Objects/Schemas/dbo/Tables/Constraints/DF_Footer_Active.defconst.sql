ALTER TABLE [dbo].[Footer]
    ADD CONSTRAINT [DF_Footer_Active] DEFAULT ((1)) FOR [Active];

