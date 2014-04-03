CREATE TABLE [dbo].[FormPendingConfirmation] (
    [IdFormPendingConfirmation] INT      IDENTITY (1, 1) NOT NULL,
    [IdForm]                    INT      NULL,
    [IdSubcribersList]          INT      NOT NULL,
    [IdSubcriber]               INT      NOT NULL,
    [UTCSubscriptionDate]       DATETIME NOT NULL,
    [Confirmed]                 BIT      NOT NULL
);



