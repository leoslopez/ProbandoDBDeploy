CREATE TABLE [dbo].[BlacklistEntry] (
    [BlacklistEntryId] INT           IDENTITY (1, 1) NOT NULL,
    [CampaignId]       INT           NOT NULL,
    [Name]             VARCHAR (150) NULL,
    [LastName]         VARCHAR (150) NULL,
    [Email]            VARCHAR (100) NOT NULL,
    [Comment]          VARCHAR (300) NULL,
    PRIMARY KEY CLUSTERED ([BlacklistEntryId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);

