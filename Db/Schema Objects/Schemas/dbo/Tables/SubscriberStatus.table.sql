CREATE TABLE [dbo].[SubscriberStatus] (
    [IdSubscriberStatus]		INT           IDENTITY (1, 1) NOT NULL,
    [Name]						NVARCHAR (50)	NOT NULL,
    [EditionLocked]				BIT				NULL,
	[IsForMonthlyBySubscriber]	BIT				NULL
) ON [Subscriber]