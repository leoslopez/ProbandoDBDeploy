CREATE TABLE [dbo].[CampaignDeliveriesOpenInfoTemp] (
    [IdCampaign]       INT          NOT NULL,
    [IdSubscriber]     INT          NOT NULL,
    [IpAddress]        VARCHAR (50) NULL,
    [LocId]            INT          NULL,
    [IdPlatform]       INT          NULL,
    [IdUserMailAgent]  INT          NULL,
    [Count]            INT          NOT NULL,
    [Date]             DATETIME     NOT NULL,
    [IdDeliveryStatus] INT          NULL
);

