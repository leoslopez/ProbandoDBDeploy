CREATE TABLE [dbo].[BlacklistEntry] (
    [BlacklistEntryId] INT           IDENTITY (1, 1) PRIMARY KEY,
    [CampaignId]       INT           NOT NULL,
    [Name]             VARCHAR (150) NULL,
    [LastName]         VARCHAR (150) NULL,
    [Email]            VARCHAR (100) NOT NULL,
    [Comment]          VARCHAR (300) NULL
    );