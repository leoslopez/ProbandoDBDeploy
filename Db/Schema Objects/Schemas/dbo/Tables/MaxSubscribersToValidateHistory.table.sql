CREATE TABLE [dbo].[MaxSubscribersToValidateHistory] (
    [IdMaxSubscribersToValidateHistory] INT            IDENTITY (1, 1) NOT NULL,
    [Reason]                            NVARCHAR (MAX) NULL,
    [IdAdmin]                           INT            NULL,
    [Date]                              DATETIME       NOT NULL,
    [IdUser]                            INT            NOT NULL,
    [MaxSubscribersToValidate]          INT            NOT NULL
);



