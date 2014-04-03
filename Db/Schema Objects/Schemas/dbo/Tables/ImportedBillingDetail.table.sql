CREATE TABLE [dbo].[ImportedBillingDetail] (
    [IdImportedBillingDetail] INT           IDENTITY (1, 1) NOT NULL,
    [IdImportedBilling]       INT           NOT NULL,
    [IdUser]                  INT           NOT NULL,
    [Email]                   VARCHAR (550) NOT NULL,
    [ClientTypePlan]          VARCHAR (50)  NOT NULL,
    [Month]                   VARCHAR (20)  NOT NULL,
    [Amount]                  DECIMAL (18, 2)  NOT NULL,
    [ExtraMonth]              VARCHAR (20)  NOT NULL,
    [ExtraAmount]             DECIMAL (18, 2)  NOT NULL,
    [Processed]               BIT           NOT NULL,
    [Extra]                   INT           NOT NULL
);





