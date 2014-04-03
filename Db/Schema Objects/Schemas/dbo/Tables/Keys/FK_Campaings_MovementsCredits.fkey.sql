ALTER TABLE [dbo].[MovementsCredits]
    ADD CONSTRAINT [FK_Campaings_MovementsCredits] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE NO ACTION ON UPDATE NO ACTION;

