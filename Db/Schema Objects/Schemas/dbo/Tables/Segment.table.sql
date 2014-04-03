CREATE TABLE [dbo].[Segment] (
    [IdSegment]              INT NOT NULL,
    [IdSegmentType]          INT NOT NULL,
    [IdCriterioPorRanking]   INT NULL,
    [IdCriterioPorRedSocial] INT NULL,
    [IdFilter]               INT NULL,
    [IsProcessing]           BIT NOT NULL,
    [CountSubscriberSegment] INT NULL,
    [IsCampaingSending]      BIT NULL
);



