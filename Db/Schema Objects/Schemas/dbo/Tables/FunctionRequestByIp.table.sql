CREATE TABLE [dbo].[FunctionRequestByIp] (
    [SourceIPAddress]   VARCHAR (50) NOT NULL,
    [FunctionRequested] INT          NOT NULL,
    [Quantity]          INT          NOT NULL,
    [LastRequest]       DATETIME     NOT NULL
);

