ALTER TABLE [dbo].[ForwardFriend]
    ADD CONSTRAINT [FK_ForwardedCampaign_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE NO ACTION ON UPDATE NO ACTION;

