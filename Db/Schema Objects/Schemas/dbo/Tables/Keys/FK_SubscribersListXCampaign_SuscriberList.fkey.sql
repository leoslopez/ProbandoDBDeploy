ALTER TABLE [dbo].[SubscribersListXCampaign]
    ADD CONSTRAINT [FK_SubscribersListXCampaign_SuscriberList] FOREIGN KEY ([IdSubscribersList]) REFERENCES [dbo].[SubscribersList] ([IdSubscribersList]) ON DELETE NO ACTION ON UPDATE NO ACTION;

