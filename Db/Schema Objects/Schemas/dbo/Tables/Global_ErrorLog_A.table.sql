CREATE TABLE [dbo].[ErrorLog] (
    [id]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TimeStamp]    DATETIME       NOT NULL,
    [Message]      VARCHAR (2000) NULL,
    [URL]          VARCHAR (500)  NULL,
    [Browser]      VARCHAR (250)  NULL,
    [UserAgent]    VARCHAR (250)  NULL,
    [SourceModule] VARCHAR (250)  NULL
);






