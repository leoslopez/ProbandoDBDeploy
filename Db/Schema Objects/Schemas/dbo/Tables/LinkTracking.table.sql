CREATE TABLE [dbo].[LinkTracking] (
	[IdLinkTracking] [int] IDENTITY(1,1) NOT NULL,
	[IdLink] [int] NOT NULL,
	[IdSubscriber] [int] NOT NULL,
	[Count] [int] NOT NULL,
	[Date] [datetime] NOT NULL
) ON [Campaign]
