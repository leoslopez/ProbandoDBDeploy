CREATE TABLE [dbo].[BlackListEntry] (
    [BlacklistEntryId] INT           IDENTITY (1, 1) NOT NULL,
    [CampaignId]       INT           NOT NULL,
    [Name]             VARCHAR (150) NULL,
    [LastName]         VARCHAR (150) NULL,
    [Email]            VARCHAR (100) NOT NULL,
    [Comment]          VARCHAR (300) NULL,
    [AdminApproved]    INT           NULL,
    [UploadedDate]     DATETIME      NULL,
    [EntryStatus]      INT           NOT NULL,
    [Ip]               NVARCHAR (15) NULL,
    PRIMARY KEY CLUSTERED ([BlackListEntryId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);





