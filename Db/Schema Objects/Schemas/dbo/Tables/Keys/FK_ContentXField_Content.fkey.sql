ALTER TABLE [dbo].[ContentXField]
    ADD CONSTRAINT [FK_ContentXField_Content] FOREIGN KEY ([IdContent]) REFERENCES [dbo].[Content] ([IdCampaign]) ON DELETE CASCADE ON UPDATE NO ACTION;

