CREATE TABLE [dbo].[ClientManagerNote] (
    [IdClientManagerNote] INT           IDENTITY (1, 1) NOT NULL,
    [Description]         VARCHAR (500) NOT NULL,
    [UTCCreationDate]     DATETIME      NOT NULL,
    [IdClientManager]     INT           NOT NULL
);

