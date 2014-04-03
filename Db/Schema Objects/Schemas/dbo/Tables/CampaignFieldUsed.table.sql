CREATE TABLE [dbo].[CampaignFieldUsed] (
    [IdCampaign]   INT           NOT NULL,
    [IdSubscriber] BIGINT        NOT NULL,
    [IdField]      INT           NOT NULL,
    [Value]        VARCHAR (200) NULL
) ON [Campaign] WITH (DATA_COMPRESSION = PAGE);





