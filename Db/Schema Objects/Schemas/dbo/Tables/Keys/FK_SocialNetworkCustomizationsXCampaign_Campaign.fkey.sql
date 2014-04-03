ALTER TABLE [dbo].[SocialNetworkCustomizationsXCampaign]
    ADD CONSTRAINT [FK_SocialNetworkCustomizationsXCampaign_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE NO ACTION ON UPDATE NO ACTION;

