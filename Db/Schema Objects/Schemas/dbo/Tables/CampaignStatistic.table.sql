CREATE TABLE [dbo].[CampaignStatistic] (
    [IdCampaign]				INT           NOT NULL,
	[DistinctOpenedMailCount]	INT           NOT NULL,
	[TotalOpenedMailCount]		INT           NOT NULL,
    [LastOpenedEmailDate]		DATETIME      NULL,
	[UnopenedMailCount]			INT           NOT NULL,
	[HardBouncedMailCount]		INT           NOT NULL,
	[SoftBouncedMailCount]		INT           NOT NULL,
	[DistinctClickedMailCount]	INT           NOT NULL,
    [TotalClickedMailCount]		INT           NOT NULL,
	[LastClickedEmailDate]		DATETIME      NULL,
	[IsWinner]					BIT			  NOT NULL	
);

















