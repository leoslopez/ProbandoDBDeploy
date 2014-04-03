ALTER TABLE [dbo].[SocialFanPageAutoPublishXCampaign]
    ADD CONSTRAINT [FK_SocialFanPageAutoPublishXCampaign_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE NO ACTION ON UPDATE NO ACTION;

