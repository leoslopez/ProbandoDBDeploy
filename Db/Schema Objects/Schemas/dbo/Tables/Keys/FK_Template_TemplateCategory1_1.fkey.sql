﻿ALTER TABLE [dbo].[Template]
    ADD CONSTRAINT [FK_Template_TemplateCategory1] FOREIGN KEY ([IdTemplateCategory]) REFERENCES [dbo].[TemplateCategory] ([IdTemplateCategory]) ON DELETE NO ACTION ON UPDATE NO ACTION;

