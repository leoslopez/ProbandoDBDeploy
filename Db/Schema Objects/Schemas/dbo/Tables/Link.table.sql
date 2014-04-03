CREATE TABLE [dbo].[Link] (
    [IdLink] [int] IDENTITY(10000000, 1) NOT NULL,
	[IdCampaign] [int] NOT NULL,
	[UrlLink] [nvarchar](max) NOT NULL,
	[IsActiveForTracking] [bit] NOT NULL,
) ON [Campaign]



