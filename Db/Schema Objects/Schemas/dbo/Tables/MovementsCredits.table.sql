CREATE TABLE [dbo].[MovementsCredits] (
    [IdMovementCredit] INT           IDENTITY (150000, 1) NOT NULL,
    [IdUser]           INT           NOT NULL,
    [Date]             DATETIME      NOT NULL,
    [CreditsQty]       INT           NOT NULL,
    [IdCampaign]       INT           NULL,
    [IdBillingCredit]  INT           NULL,
    [PartialBalance]   INT           NOT NULL,
    [IdAdmin]          INT           NULL,
    [ConceptEnglish]   VARCHAR (MAX) NULL,
    [IdUserType]       INT           NULL,
    [Visible]          BIT           NULL,
    [ConceptSpanish]   VARCHAR (MAX) NULL
);













