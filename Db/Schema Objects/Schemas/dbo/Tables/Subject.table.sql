CREATE TABLE [dbo].[Subject] (
    [IdSubject]   INT           IDENTITY (1, 1) NOT NULL,
    [IdCampaign]  INT           NOT NULL,
    [Description] VARCHAR (100) NOT NULL,
    [Tag]         CHAR (1)      NULL
);



