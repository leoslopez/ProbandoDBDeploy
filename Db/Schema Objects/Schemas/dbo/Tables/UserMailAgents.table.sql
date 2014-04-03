CREATE TABLE [dbo].[UserMailAgents] (
    [IdUserMailAgent]     INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VersionName]         VARCHAR (50) NOT NULL,
    [IdUserMailAgentType] INT          NOT NULL
);



