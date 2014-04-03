CREATE TABLE [dbo].[Content] (
    [IdCampaign] INT  NOT NULL,
    [Content]    NVARCHAR(MAX) NULL,
    [PlainText]  NVARCHAR(MAX) NULL,
	[IsPlainTextUpdated] BIT DEFAULT((0)) NOT NULL,
	[IdTemplate] INT NULL
) ON [Campaign] TEXTIMAGE_ON [Campaign]




