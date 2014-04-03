CREATE TABLE [dbo].[UnsubscriptionReason]
(
	[IdUnsubscriptionReason]	INT    IDENTITY (1, 1) NOT NULL,
    [Name]						VARCHAR (150)	NOT NULL,
    [VisibleByUser]				BIT				NOT NULL
)