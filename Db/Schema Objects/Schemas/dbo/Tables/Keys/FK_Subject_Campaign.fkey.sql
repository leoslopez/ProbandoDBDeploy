ALTER TABLE [dbo].[Subject]
    ADD CONSTRAINT [FK_Subject_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE NO ACTION ON UPDATE NO ACTION;

