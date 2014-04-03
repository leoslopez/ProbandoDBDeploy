ALTER TABLE [dbo].[Subscriber]
    ADD CONSTRAINT [FK_Subscriber_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE NO ACTION ON UPDATE NO ACTION;

