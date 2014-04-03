CREATE TABLE [dbo].[MailConfirmation] (
    [IdMailConfirmation] INT          IDENTITY (1, 1) NOT NULL,
    [IdUser]             INT          NOT NULL,
    [Mail]               VARCHAR (50) NOT NULL,
    [Active]             BIT          NOT NULL
);



