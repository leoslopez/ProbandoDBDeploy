CREATE TYPE [dbo].[TypeRegisterOpen] AS  TABLE (
    [AutoIncrement]   BIT           NULL,
    [CountOpens]      INT           NULL,
    [IdCampaign]      INT           NULL,
    [IdPlatform]      INT           NULL,
    [IdSubscriber]    INT           NULL,
    [IdUserMailAgent] INT           NULL,
    [IpAddress]       VARCHAR (100) NULL,
    [IpNumber]        BIGINT        NULL,
    [OpenDate]        DATETIME      NULL,
    [LocId]           INT           NULL);

