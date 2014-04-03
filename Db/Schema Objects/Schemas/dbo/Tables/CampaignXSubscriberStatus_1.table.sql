CREATE TABLE [dbo].[CampaignXSubscriberStatus] (
    [IdCampaign]   INT NOT NULL,
    [IdSubscriber] INT NOT NULL,
    [Sent]         BIT NULL
) ON [Campaign];

