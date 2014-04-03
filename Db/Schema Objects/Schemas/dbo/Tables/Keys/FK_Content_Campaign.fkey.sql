ALTER TABLE [dbo].[Content]
    ADD CONSTRAINT [FK_Content_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE CASCADE ON UPDATE NO ACTION;

