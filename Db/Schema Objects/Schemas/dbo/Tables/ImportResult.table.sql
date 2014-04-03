CREATE TABLE [dbo].[ImportResult] (
    [IdImportResult]                  INT IDENTITY (1, 1) NOT NULL,
    [Proccesed]                       INT NULL,
    [InvalidEmails]                   INT NULL,
    [SoftBounceds]                    INT NULL,
    [HardBounceds]                    INT NULL,
    [SubscriberBounceds]              INT NULL,
    [AmountHeadersAndFieldsDontMatch] INT NULL,
    [NeverOpenBounceds]               INT NULL,
    [Updated]                         INT NULL,
    [NewSubscribers]                  INT NULL,
    [Duplicated]                      INT NULL,
    [UnsubscribedByUser]              INT NULL,
	[UsersInBlackList]				  INT NULL
);





