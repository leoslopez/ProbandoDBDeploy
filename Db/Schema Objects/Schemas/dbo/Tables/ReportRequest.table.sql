CREATE TABLE [dbo].[ReportRequest] (
    [IdRequest]         INT           IDENTITY (150000, 1) NOT FOR REPLICATION NOT NULL,
    [IdCampaign]        INT           NOT NULL,
    [ReportType]        VARCHAR (100) NULL,
    [RequestExportType] VARCHAR (50)  NOT NULL,
    [Status]            VARCHAR (50)  NOT NULL,
    [TimeStamp]         DATETIME      NOT NULL,
    [Language]          VARCHAR (50)  NOT NULL,
    [Progress]          INT           NULL,
    [URLPath]           VARCHAR (500) NULL,
    [FileName]          VARCHAR (250) NULL,
    [EmailAlert]        VARCHAR (250) NULL,
    [Filter]            VARCHAR (200) NULL,
    [FirstNameFilter]   NVARCHAR (50) NULL,
    [LastNameFilter]    NVARCHAR (50) NULL,
    [EmailFilter]       VARCHAR (50)  NULL,
    [Active]            BIT           NOT NULL,
    [IdCampaignStatus]  INT           NULL
);








