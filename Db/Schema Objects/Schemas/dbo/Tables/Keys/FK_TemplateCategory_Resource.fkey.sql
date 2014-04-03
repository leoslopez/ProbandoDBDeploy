ALTER TABLE [dbo].[TemplateCategory]
    ADD CONSTRAINT [FK_TemplateCategory_Resource] FOREIGN KEY ([IdResource]) REFERENCES [dbo].[Resource] ([IdResource]) ON DELETE NO ACTION ON UPDATE NO ACTION;


