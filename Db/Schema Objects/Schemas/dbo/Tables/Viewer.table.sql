CREATE TABLE [dbo].[Viewer] (
    [IdViewer]               INT           IDENTITY (1, 1) NOT NULL,
    [Username]               VARCHAR (20)  NOT NULL,
    [Password]               VARCHAR (50)  NOT NULL,
    [Active]                 BIT           NOT NULL,
    [UTCRegisterDate]        DATETIME      NOT NULL,
    [Email]                  VARCHAR (100) NULL,
    [IdClientManager]        INT           NOT NULL,
    [VerificationCode]       VARCHAR (300) NULL,
    [AnswerSecurityQuestion] VARCHAR (MAX) NULL,
    [IdSecurityQuestion]     INT           NULL,
    [AccountValidated]       BIT           NULL
);







