ALTER TABLE [dbo].[Link]
    ADD CONSTRAINT [FK_Link_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE CASCADE ON UPDATE NO ACTION;

