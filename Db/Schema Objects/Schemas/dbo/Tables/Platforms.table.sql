CREATE TABLE [dbo].[Platforms] (
    [IdPlatform]     INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VersionName]    VARCHAR (50) NOT NULL,
    [IdPlatformType] INT          NOT NULL
);



