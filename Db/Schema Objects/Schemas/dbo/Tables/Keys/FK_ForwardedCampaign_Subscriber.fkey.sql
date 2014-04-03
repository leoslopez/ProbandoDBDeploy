ALTER TABLE [dbo].[ForwardFriend]
    ADD CONSTRAINT [FK_ForwardedCampaign_Subscriber] FOREIGN KEY ([IdSubscriber]) REFERENCES [dbo].[Subscriber] ([IdSubscriber]) ON DELETE NO ACTION ON UPDATE NO ACTION;

