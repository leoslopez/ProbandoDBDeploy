ALTER TABLE [dbo].[Campaign]
    ADD CONSTRAINT [FK_Campaign_ParentCampaign] FOREIGN KEY ([IdParentCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE NO ACTION ON UPDATE NO ACTION;

